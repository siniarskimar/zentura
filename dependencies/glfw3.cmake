find_package("PkgConfig" QUIET)
find_package("GLFW" QUIET COMPONENTS "glfw3")
if(NOT GLFW_FOUND)
    set(source_url "https://github.com/glfw/glfw/releases/download/3.3.8/glfw-3.3.8.zip")
    set(archive_loc "${CMAKE_CURRENT_LIST_DIR}/glfw-3.3.8.zip")
    set(source_root "${CMAKE_CURRENT_LIST_DIR}/glfw-3.3.8")
    message(STATUS "GLFW not found on system! Attempting to use GLFW source.")
    if(NOT EXISTS "${source_root}" OR NOT EXISTS "${source_root}/CMakeLists.txt")
        if(NOT EXISTS "${archive_loc}")
            message(STATUS "Downloading ${source_url}")
            file(DOWNLOAD ${source_url} ${archive_loc}
                INACTIVITY_TIMEOUT 20
                SHOW_PROGRESS
                STATUS download_status
            )
            list(GET download_status 0 error)
            if(NOT ${error} EQUAL 0)
                list(GET download_status 1 error)
                message(FATAL_ERROR "Error during download: ${error}")
            endif()
        endif()
        if(NOT EXISTS "${source_root}/CMakeLists.txt")
            message(STATUS "Extracting ${archive_loc}")
            file(ARCHIVE_EXTRACT
                INPUT "${archive_loc}"
                DESTINATION "${CMAKE_CURRENT_LIST_DIR}"
            )
        endif()

    endif()

    set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build GLFW shared libraries" FORCE)
    set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "Build the GLFW example programs" FORCE)
    set(GLFW_BUILD_TESTS OFF CACHE BOOL "Build the GLFW test programs" FORCE)
    set(GLFW_BUILD_DOCS OFF CACHE BOOL "Build the GLFW documentation" FORCE)
    set(GLFW_INSTALL OFF CACHE BOOL "Generate installation target" FORCE)
    set(GLFW_VULKAN_STATIC OFF CACHE BOOL "Assume the Vulkan loader is linked with the application" FORCE)
    
    include_directories("${source_root}/include")
    if(EXISTS "${source_root}/CMakeLists.txt")
        add_subdirectory("${source_root}")
    else()
        message(FATAL_ERROR "${source_root} doesn't have a CMakeLists.txt file!")
    endif()
endif()