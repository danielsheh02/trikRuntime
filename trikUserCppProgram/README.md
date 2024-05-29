## How to run an algorithm implemented in C++ on TRIK controller

### Step 0
For ease of development, it is recommended to clone this repository and write algorithms inside the `trikUserCppProgram` module.

### Step 1
To compile a program for the TRIK controller platform, you need to install the [SDK](https://dl.trikset.com/distro/latest-full/trik-sdk-x86_64-arm926ejse-toolchain-trik-nodistro.0.sh). To do this, you need to save and run the .sh file available at the link.

To use the tools from the SDK, you need to export the environment:

```
. /opt/trik-sdk/environment-setup-arm926ejse-oe-linux-gnueabi
```

### Step 2
Implementation of the algorithm.

You need to implement this interface for your custom class:
```cpp
class UserCppClassInterface
{
public:
    UserCppClassInterface() = default;
    virtual ~UserCppClassInterface() = default;
    virtual void startProgram() = 0;
};
```

You must implement a factory function that will return an instance of your custom class:
```cpp
#include <trikControl/brickInterface.h>
#include <trikNetwork/mailboxInterface.h>
#include <trikScriptRunner/trikScriptControlInterface.h>

extern "C" {
UserCppClass *createMyObject(BrickInterface *brick, 
                            MailboxInterface *mailbox, 
                            TrikScriptControlInterface *trikScriptControl) 
{
    return UserCppClass::create(brick, mailbox, trikScriptControl);
}
}
```

Implementing of your custom class:

```cpp
#include <trikScriptRunner/userCppClassInterface.h>
#include <trikControl/brickInterface.h>
#include <trikNetwork/mailboxInterface.h>
#include <trikScriptRunner/trikScriptControlInterface.h>

class UserCppClass : UserCppClassInterface
{
private:
    UserCppClass(... *brick, ... *mailbox, 
                 ... *trikScriptControl);

public:
    ~UserCppClass();
    static UserCppClass *create(... *brick, ... *mailbox, 
                                ... *trikScriptControl);
    void startProgram() override;
};
```

You can see an example of the algorithm `along the box` implemented in C++ in the `trikUserCppProgram` module.

### Step 3
To compile the implemented program, you need to generate a Makefile using the qmake tool:
```
qmake .../trikRuntime/trikUserCppProgram/trikUserCppProgram.pro
```

To get the dynamic library file extension .so it is necessary to perform:
```
make
```

After that, this file can be uploaded and executed on the controller.
