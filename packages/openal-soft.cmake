ExternalProject_Add(openal-soft
    DEPENDS
        libsdl2
    GIT_REPOSITORY https://github.com/kcat/openal-soft.git
    SOURCE_DIR ${SOURCE_LOCATION}
    # 上游 master 已把部分源文件改成 C++20 模块（HAVE_CXXMODULES 下的 import openal），
    # 当前 clang sysroot 下 CMake 的模块扫描没能把 BMI 传给 import 方，四架构都报
    # "fatal error: module 'openal' not found"。关掉模块，走源码里的头文件分支。
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DLIBTYPE=STATIC
        -DALSOFT_UTILS=OFF
        -DALSOFT_EXAMPLES=OFF
        -DALSOFT_TESTS=OFF
        -DALSOFT_BACKEND_PIPEWIRE=OFF
        -DALSOFT_ENABLE_MODULES=OFF
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
          COMMAND bash -c "echo 'Libs.private: -lole32 -luuid -lshlwapi' >> <BINARY_DIR>/openal.pc"
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(openal-soft)
cleanup(openal-soft install)
