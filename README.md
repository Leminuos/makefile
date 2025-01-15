# GCC

**Preprocessor:** gcc -E main.c -o main.i

**Compilation:** gcc -S main.i -o main.s

**Assemble:** as main.s -o main.o

**Linking:** gcc -v -o main main.o

# Command Arm Toolchain

**Compile/Linker**

[Compiler Options] **-o** [Target] [All prerequisite]

[Linker Options] **-o** [Target] [All prerequisite]

Compiler Options

- arm-none-eabi-gcc
- -mcpu=cortex-m4
- -mthumb
- -std=gnu11
- -Ox
- I$(INCLUDE_DIR)

Linker Options

- arm-none-eabi-ld
- -T $(LINKER_FILE)
- -Map [path_to_file.map]
- -nostdlib

**Create hex, bin, elf for Microcontrollers**

Object Copy to Create hex file

**objcopy.exe -O ihex** [file elf] [file hex]

**Nạp code**

- **ST_LINK_CLI.exe -ME**
- **ST_LINK_CLI.exe -p** [file hex] [Địa chỉ bắt đầu nạp code]
- **ST_LINK_CLI.exe -rst**

# Makefile

Makefile chứa:

- Explicit rule
- Implicit rule
- Variable definition
- Directive: Reading another makefile, deciding (based on the values of variables) whether to use or ignore a part of the makefile
- Comment

**Explicit Rule**

- target: Action/File target
- prerequisites: Input files to make target
- recipe: Action that make carry out

```
target ... : prerequisites ...
    recipe
    ...
    ...
```

**Including Other Makefiles**

**include** direction sẽ tạm dừng đọc makefile hiện tại và đọc các makefile khác trước khi tiếp tục.

```
include filenames…
```

Nếu muốn make bỏ qua một makefile không tồn tại hoặc không thể tạo, không có thông bảo lỗi thì có thể sử dụng câu lệnh sau.
Lệnh này hoạt động giống như lệnh trên, ngoại trừ việc nó không có cảnh báo lỗi nếu không có tồn tại một makefile.

```
-include filenames
```

**Automatic Variables**

| Symbol | Meaning                             |
| ------ | ----------------------------------- |
| $@     | File name of the target of the rule |
| $^     | Name of all the prerequisite        |
| $<     | Name of the first prerequisite      |

**Wildcard Functions**

Một tên tệp duy nhất có thể chỉ định nhiều tệp bằng cách sử dụng các **wildcard character**.
Các wildcard character trong make là '*', '?', và '[...]'.

```
Ví dụ:

clean:
    rm -f *.o
```

Wildcard expansion sẽ không hợp lệ khi định nghĩa một variable. Ví dụ, nếu viết như sau:

```
objects = *.o
```

=> giá trị của objects sẽ là chuỗi '*.o'. Tuy nhiên, nếu sử dụng giá trị của objects ở target hoặc prerequisite
thì Wildcard expansion sẽ xảy ra tại đây. Để có thể thực hiện Wildcard expansion khi định nghĩa variable, ta sử dụng:

```
objects := $(wildcard *.o)
```

Ta có thể thay đổi list các file source C thành list các file object bằng cách thay thế '.c' thành '.o' như sau:

```
$(patsubst %.c,%.o,$(wildcard *.c))
```

**Functions for String Substitution and Analysis**

*$(subst from,to,text)*: Thực hiện thay thế text. Ví dụ:

```
$(subst ee,EE,feet on the street)
```

tạo ra giá trị ‘fEEt on the strEEt’.

*$(patsubst pattern,replacement,text)*: Tìm các word được phân cách bằng space trong text khớp với **pattern**
và thực hiện thay thế chung bằng **replacement**.

```
$(patsubst %.c,%.o,x.c.c bar.c)
```

tạo ra giá trị ‘x.c.o bar.o’.

*Substitution references* là cách đơn giản hơn tương tự với hàm patsubst. Cấu trúc:

```
$(var:pattern=replacement)
```

tương đương với

```
$(patsubst pattern,replacement,$(var))
```

Ví dụ, ta có một list các file object:

```
objects = foo.o bar.o baz.o
```

Để có list các file source tương ứng, ta chỉ cần viết:

```
$(objects:.o=.c)
```

thay vì sử dụng dạng general:

```
$(patsubst %.o,%.c,$(objects))
```

> **Link tham khảo:** (https://www.gnu.org/software/make/manual/make.html#Text-Functions)

**Foreach Functions**

Foreach function khiến một đoạn văn bản được sử dụng nhiều lần, mỗi lần sẽ các substitution thay thế khác nhau được thực hiện.

Cú pháp *foreach* function là:

```
$(foreach var,list,text)
```

Duyệt lần lượt từng word trong list, sau đó gán cho var và text được expand.

Ví dụ variable *files* chứa list tất cả các file trong các thư mục *dirs*:

```
dirs := abcd 
files := $(foreach dir,$(dirs),$(wildcard $(dir)/*))
```

- Lần lặp lại đầu tiên thấy giá trị 'a' => '$(wildcard a/*)'
- Lần lặp lại thứ hai thấy giá trị 'b' => '$(wildcard b/*)'
- Lần lặp lại đầu tiên thấy giá trị 'c' => '$(wildcard c/*)'

=> Kết quả của ví dụ này sẽ là:

```
files := $(wildcard a/* b/* c/* d/*)
```

> **Link tham khảo:** (https://www.gnu.org/software/make/manual/make.html#Foreach-Function)

**direction vpath**

Sử dụng direction **vpath** khi muốn lấy các file trong các folder khác nhau => sẽ tự động tìm kiếm các file khớp với pattern trong các đường dẫn. Có 3 hình thức diraction **vpath**:

**vpath pattern directories**: Chỉ định đường dẫn folder cho các tệp khớp với pattern. Trong đó pattern phải là một chuỗi chứa ký tự '%'.

**vpath pattern**: Xóa đường dẫn liên quan đến pattern

**vpath**: Xóa tất cả các đường dẫn đã được chỉ định trước đó.

```
#search path .c and .h files
vpath %.c $(SRC_DIRS)
vpath %.h $$(INC_DIRS)
```

Yêu cầu make tìm kiếm các file có tên kết thúc bằng .c trong folder **SRC_DIRS** nếu file không được tìm thấy trong folder hiện tại.

**Variable VPATH**

Sử dụng biến VPATH như một danh sách tìm kiếm cho các prerequisite và target => một file được liệt kê tại
target và prerequisite không được tìm thấy trong folder hiện tại thì nó sẽ tìm kiếm trong các folder được liệt kê trong biến VPATH.

Ví dụ:

```
VPATH = src:../headers

# Đối với rule sau

foo.o : foo.c

# Giả sử file foo.c không tồn tại trong folder hiện tại nhưng được tìm thấy trong folder src

foo.o : src/foo.c
```

**Pattern Rules**

Tạo file .o từ file .c tương ứng.

```
%.o:%c
    recipes
```