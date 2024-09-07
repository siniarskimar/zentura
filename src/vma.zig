const std = @import("std");

const zvk = @import("zig-vulkan");
const vma = @cImport({
    @cInclude("vk_mem_alloc.h");
});

pub const Allocator = vma.VmaAllocator;
pub const Allocation = vma.VmaAllocation;
pub const AllocationInfo = vma.VmaAllocationInfo;
pub const VulkanFunctions = vma.VmaVulkanFunctions;
pub const AllocatorCreateInfo = vma.VmaAllocatorCreateInfo;

pub const VK_API_VERSION_1_0 = vma.VK_API_VERSION_1_0;
pub const VK_API_VERSION_1_1 = vma.VK_API_VERSION_1_1;
pub const VK_API_VERSION_1_2 = vma.VK_API_VERSION_1_2;
pub const VK_API_VERSION_1_3 = vma.VK_API_VERSION_1_3;

pub const MemoryUsage = enum(c_uint) {
    unknown = vma.VMA_MEMORY_USAGE_UNKNOWN,
    gpu_only = vma.VMA_MEMORY_USAGE_GPU_ONLY,
    cpu_only = vma.VMA_MEMORY_USAGE_CPU_ONLY,
    cpu_to_gpu = vma.VMA_MEMORY_USAGE_CPU_TO_GPU,
    gpu_to_cpu = vma.VMA_MEMORY_USAGE_GPU_TO_CPU,
    gpu_lazily_allocated = vma.VMA_MEMORY_USAGE_GPU_LAZILY_ALLOCATED,
    auto = vma.VMA_MEMORY_USAGE_AUTO,
    auto_prefer_device = vma.VMA_MEMORY_USAGE_AUTO_PREFER_DEVICE,
    auto_prefer_host = vma.VMA_MEMORY_USAGE_AUTO_PREFER_HOST,
};

pub const AllocationCreateFlags = packed struct(c_int) {
    dedicated_memory_bit: bool = false,
    never_allocate_bit: bool = false,
    mapped_bit: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    user_data_copy_string_bit: bool = false,
    upper_address_bit: bool = false,
    dont_bind_bit: bool = false,
    within_budget_bit: bool = false,
    can_alias_bit: bool = false,
    host_access_sequential_bit: bool = false,
    host_access_random_bit: bool = false,
    host_access_allow_transfer_instead_bit: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    /// alias: min_memory_bit
    strategy_best_fit_bit: bool = false,
    /// alias: min_time_bit
    strategy_first_fit_bit: bool = false,
    strategy_min_offset_bit: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,

    pub const strategy_mask: c_int = @bitCast(AllocationCreateFlags{
        .strategy_best_fit_bit = true,
        .strategy_first_fit_bit = true,
        .strategy_min_offset_bit = true,
    });

    comptime {
        std.debug.assert(strategy_mask == vma.VMA_ALLOCATION_CREATE_STRATEGY_MASK);
    }
};

pub const AllocationCreateInfo = extern struct {
    flags: AllocationCreateFlags = .{},
    usage: MemoryUsage,
    required_flags: zvk.MemoryPropertyFlags = .{},
    preferred_flags: zvk.MemoryPropertyFlags = .{},
    memory_type_bits: u32 = @import("std").mem.zeroes(u32),
    pool: vma.VmaPool = null,
    pUserData: ?*anyopaque = null,
    priority: f32 = 0,

    comptime {
        std.debug.assert(@sizeOf(AllocationCreateInfo) == @sizeOf(vma.VmaAllocationCreateInfo));
    }
};

pub const createAllocator = vma.vmaCreateAllocator;
pub const destroyAllocator = vma.vmaDestroyAllocator;

pub fn createBuffer(
    vma_alloc: Allocator,
    buffer_create_info: zvk.BufferCreateInfo,
    allocation_create_info: AllocationCreateInfo,
    allocation: *Allocation,
    allocation_info: ?*vma.VmaAllocationInfo,
) !zvk.Buffer {
    var buffer: zvk.Buffer = .null_handle;
    const result: zvk.Result = @enumFromInt(vma.vmaCreateBuffer(
        vma_alloc,
        &@as(vma.VkBufferCreateInfo, @bitCast(buffer_create_info)),
        &@as(vma.VmaAllocationCreateInfo, @bitCast(allocation_create_info)),
        @ptrCast(&buffer),
        allocation,
        allocation_info,
    ));
    switch (result) {
        zvk.Result.success => {},
        zvk.Result.error_out_of_host_memory => return error.OutOfHostMemory,
        zvk.Result.error_out_of_device_memory => return error.OutOfDeviceMemory,
        zvk.Result.error_device_lost => return error.DeviceLost,
        zvk.Result.error_too_many_objects => return error.TooManyObjects,
        else => return error.Unknown,
    }

    return buffer;
}

pub fn destroyBuffer(vma_alloc: Allocator, buffer: zvk.Buffer, allocation: Allocation) void {
    vma.vmaDestroyBuffer(vma_alloc, @ptrFromInt(@intFromEnum(buffer)), allocation);
}
