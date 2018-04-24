	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 13
	.p2align	4, 0x90         ## -- Begin function +[NSObject(Category) Object]
"+[NSObject(Category) Object]":         ## @"\01+[NSObject(Category) Object]"
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi2:
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	L_OBJC_CLASSLIST_REFERENCES_$_(%rip), %rdi
	movq	L_OBJC_SELECTOR_REFERENCES_(%rip), %rsi
	movq	_objc_msgSend@GOTPCREL(%rip), %rax
	callq	*%rax
	movq	%rax, %rdi
	callq	_objc_retainAutoreleasedReturnValue
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rdi
	movq	_objc_retain@GOTPCREL(%rip), %rax
	callq	*%rax
	xorl	%ecx, %ecx
	movl	%ecx, %esi
	leaq	-24(%rbp), %rdi
	movq	%rax, -32(%rbp)         ## 8-byte Spill
	callq	_objc_storeStrong
	movq	-32(%rbp), %rdi         ## 8-byte Reload
	addq	$32, %rsp
	popq	%rbp
	jmp	_objc_autoreleaseReturnValue ## TAILCALL
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90         ## -- Begin function +[NSObject(Category) allocObject]
"+[NSObject(Category) allocObject]":    ## @"\01+[NSObject(Category) allocObject]"
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi3:
	.cfi_def_cfa_offset 16
Lcfi4:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi5:
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	L_OBJC_CLASSLIST_REFERENCES_$_(%rip), %rsi
	movq	L_OBJC_SELECTOR_REFERENCES_.2(%rip), %rdi
	movq	%rdi, -24(%rbp)         ## 8-byte Spill
	movq	%rsi, %rdi
	movq	-24(%rbp), %rsi         ## 8-byte Reload
	callq	_objc_msgSend
	movq	L_OBJC_SELECTOR_REFERENCES_.4(%rip), %rsi
	movq	%rax, %rdi
	callq	_objc_msgSend
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__DATA,__objc_classrefs,regular,no_dead_strip
	.p2align	3               ## @"OBJC_CLASSLIST_REFERENCES_$_"
L_OBJC_CLASSLIST_REFERENCES_$_:
	.quad	_OBJC_CLASS_$_NSMutableArray

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_:                  ## @OBJC_METH_VAR_NAME_
	.asciz	"array"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.p2align	3               ## @OBJC_SELECTOR_REFERENCES_
L_OBJC_SELECTOR_REFERENCES_:
	.quad	L_OBJC_METH_VAR_NAME_

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.1:                ## @OBJC_METH_VAR_NAME_.1
	.asciz	"alloc"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.p2align	3               ## @OBJC_SELECTOR_REFERENCES_.2
L_OBJC_SELECTOR_REFERENCES_.2:
	.quad	L_OBJC_METH_VAR_NAME_.1

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.3:                ## @OBJC_METH_VAR_NAME_.3
	.asciz	"init"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.p2align	3               ## @OBJC_SELECTOR_REFERENCES_.4
L_OBJC_SELECTOR_REFERENCES_.4:
	.quad	L_OBJC_METH_VAR_NAME_.3

	.section	__TEXT,__objc_classname,cstring_literals
L_OBJC_CLASS_NAME_:                     ## @OBJC_CLASS_NAME_
	.asciz	"Category"

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.5:                ## @OBJC_METH_VAR_NAME_.5
	.asciz	"Object"

	.section	__TEXT,__objc_methtype,cstring_literals
L_OBJC_METH_VAR_TYPE_:                  ## @OBJC_METH_VAR_TYPE_
	.asciz	"@16@0:8"

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.6:                ## @OBJC_METH_VAR_NAME_.6
	.asciz	"allocObject"

	.section	__DATA,__objc_const
	.p2align	3               ## @"\01l_OBJC_$_CATEGORY_CLASS_METHODS_NSObject_$_Category"
l_OBJC_$_CATEGORY_CLASS_METHODS_NSObject_$_Category:
	.long	24                      ## 0x18
	.long	2                       ## 0x2
	.quad	L_OBJC_METH_VAR_NAME_.5
	.quad	L_OBJC_METH_VAR_TYPE_
	.quad	"+[NSObject(Category) Object]"
	.quad	L_OBJC_METH_VAR_NAME_.6
	.quad	L_OBJC_METH_VAR_TYPE_
	.quad	"+[NSObject(Category) allocObject]"

	.p2align	3               ## @"\01l_OBJC_$_CATEGORY_NSObject_$_Category"
l_OBJC_$_CATEGORY_NSObject_$_Category:
	.quad	L_OBJC_CLASS_NAME_
	.quad	_OBJC_CLASS_$_NSObject
	.quad	0
	.quad	l_OBJC_$_CATEGORY_CLASS_METHODS_NSObject_$_Category
	.quad	0
	.quad	0
	.quad	0
	.long	64                      ## 0x40
	.space	4

	.section	__DATA,__objc_catlist,regular,no_dead_strip
	.p2align	3               ## @"OBJC_LABEL_CATEGORY_$"
L_OBJC_LABEL_CATEGORY_$:
	.quad	l_OBJC_$_CATEGORY_NSObject_$_Category

	.section	__DATA,__objc_imageinfo,regular,no_dead_strip
L_OBJC_IMAGE_INFO:
	.long	0
	.long	64


.subsections_via_symbols
