if(PRD_ARCHIVE_SUPPORT)
	if (NOT TARGET 7zip)
		add_subdirectory(7z)
	endif ()
	if (NOT MINIZIP_FOUND AND NOT TARGET minizip)
		add_subdirectory(minizip)
	endif()
endif()
add_subdirectory(md5)
add_subdirectory(bencode)
add_subdirectory(sha1)
if (NOT Libgit2_FOUND AND RAPIDTOOLS)
	set(ENABLE_TRACE FALSE CACHE BOOL "" FORCE)
	set(USE_HTTPS FALSE CACHE BOOL "" FORCE)
	set(USE_SSH FALSE CACHE BOOL "" FORCE)
	set(USE_NTLMCLIENT FALSE CACHE BOOL "" FORCE)
	set(BUILD_SHARED_LIBS FALSE CACHE BOOL "" FORCE)
	set(BUILD_CLAR FALSE CACHE BOOL "" FORCE)

	add_subdirectory(libgit2 EXCLUDE_FROM_ALL)
endif()
