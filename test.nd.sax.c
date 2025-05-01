#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <locale.h>


typedef enum tag {
	TAG_cons,
	TAG_false,
	TAG_nil,
	TAG_succ,
	TAG_true,
	TAG_zero
} tag;
typedef union value* addr;

typedef union value {
  tag  tag;
  addr ptr;
  addr env;
  void(*fun)(addr arg, addr env);
 int32_t i;
 } value;

static void* heap;
static unsigned long alloc_count;
static unsigned long alloc_size;

void init_heap(size_t total_size) {
  heap = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
  if (heap == MAP_FAILED) {
    printf("mmap failed");
    exit(EXIT_FAILURE);
  }
}

addr alloc(int n) {
  void* prev = heap;
  heap = heap + n * sizeof(value);
  alloc_count++;
  alloc_size += n;
  return (addr)prev;
}

void invoke_closure_fun (addr a, addr b, addr c) {
  addr arg = alloca(2 * sizeof(value));
  arg->ptr = b;
  (arg+1)->ptr = c;
  (a->fun)(arg, (a+1)->env);
}

void invoke_closure_susp (addr a, addr b) {
  addr arg = alloca(1 * sizeof(value));
  arg->ptr = b;
  (a->fun)(arg, (a+1)->env);
}

void invoke_closure_record (addr a, tag k, addr b) {
  addr arg = alloca(2 * sizeof(value));
  arg->tag = k;
  (arg+1)->ptr = b;
  (a->fun)(arg, (a+1)->env);
}


void print$nat(addr val$);
void print$nlist(addr val$);
void mylist2$0(addr s$45);
void mylist$0(addr s$25);
void addl$0(addr s$1, addr l);
void print$nat(addr val$) {
switch (val$->tag){
case TAG_succ:{
addr val$_TAG_succ = (val$+1)->ptr;
printf("'succ ");
print$nat(val$_TAG_succ);
break;
}
case TAG_zero:{
addr val$_TAG_zero = (val$+1)->ptr;
printf("'zero ");
printf("()");
break;
}
}
}
void print$nlist(addr val$) {
switch (val$->tag){
case TAG_cons:{
addr val$_TAG_cons = (val$+1)->ptr;
printf("'cons ");
addr val$_TAG_cons_pi1 = val$_TAG_cons->ptr;
addr val$_TAG_cons_pi2 = (val$_TAG_cons+1)->ptr;
printf("(");
addr val$_TAG_cons_pi1_inshift = val$_TAG_cons_pi1->ptr;
printf("<");
print$nat(val$_TAG_cons_pi1_inshift);
printf(">");
printf(", ");
print$nlist(val$_TAG_cons_pi2);
printf(")");
break;
}
case TAG_nil:{
addr val$_TAG_nil = (val$+1)->ptr;
printf("'nil ");
printf("()");
break;
}
}
}
void print$mylist2$0(addr val$) {
print$nlist(val$);
}
void print$mylist$0(addr val$) {
print$nlist(val$);
}

void mylist2$0(addr s$45) {
	addr s$47 = alloc(2);
	mylist$0(s$47);
	addl$0(s$45, s$47);
}

void mylist$0(addr s$25) {
	addr s$26 = alloc(2);
	addr s$27 = alloc(1);
	addr s$43 = alloc(2);
	addr s$44 = alloc(0);
	s$44 = NULL;
	s$43->tag = TAG_zero;
	(s$43+1)->ptr = s$44;
	s$27->ptr = s$43;
	addr s$28 = alloc(2);
	addr s$29 = alloc(2);
	addr s$30 = alloc(1);
	addr s$40 = alloc(2);
	addr s$41 = alloc(2);
	addr s$42 = alloc(0);
	s$42 = NULL;
	s$41->tag = TAG_zero;
	(s$41+1)->ptr = s$42;
	s$40->tag = TAG_succ;
	(s$40+1)->ptr = s$41;
	s$30->ptr = s$40;
	addr s$31 = alloc(2);
	addr s$32 = alloc(2);
	addr s$33 = alloc(1);
	addr s$36 = alloc(2);
	addr s$37 = alloc(2);
	addr s$38 = alloc(2);
	addr s$39 = alloc(0);
	s$39 = NULL;
	s$38->tag = TAG_zero;
	(s$38+1)->ptr = s$39;
	s$37->tag = TAG_succ;
	(s$37+1)->ptr = s$38;
	s$36->tag = TAG_succ;
	(s$36+1)->ptr = s$37;
	s$33->ptr = s$36;
	addr s$34 = alloc(2);
	addr s$35 = alloc(0);
	s$35 = NULL;
	s$34->tag = TAG_nil;
	(s$34+1)->ptr = s$35;
	s$32->ptr = s$33;
	(s$32+1)->ptr = s$34;
	s$31->tag = TAG_cons;
	(s$31+1)->ptr = s$32;
	s$29->ptr = s$30;
	(s$29+1)->ptr = s$31;
	s$28->tag = TAG_cons;
	(s$28+1)->ptr = s$29;
	s$26->ptr = s$27;
	(s$26+1)->ptr = s$28;
	s$25->tag = TAG_cons;
	(s$25+1)->ptr = s$26;
}

void addl$0(addr s$1, addr l) {
	switch (l->tag){
	case TAG_cons:{
		addr n$2 = (l+1)->ptr;
		addr n$9 = n$2->ptr;
		addr n$10 = (n$2+1)->ptr;
		addr n$18 = n$9->ptr;
		addr s$15 = alloc(2);
		addr s$16 = alloc(1);
		addr s$20 = alloc(2);
		s$20->tag = TAG_succ;
		(s$20+1)->ptr = n$18;
		s$16->ptr = s$20;
		addr s$17 = alloc(2);
		addl$0(s$17, n$10);
		s$15->ptr = s$16;
		(s$15+1)->ptr = s$17;
		s$1->tag = TAG_cons;
		(s$1+1)->ptr = s$15;
		break;
	}

	case TAG_nil:{
		addr n$2 = (l+1)->ptr;
		addr s$24 = alloc(0);
		s$24 = NULL;
		s$1->tag = TAG_nil;
		(s$1+1)->ptr = s$24;
		break;
	}
	}
}
int main (){
	init_heap(1024 * 1024);
	freopen("test.nd.val", "w", stdout);
	addr mylist2$0$value = alloc(2);
	mylist2$0(mylist2$0$value);
	printf("value %s = ", "mylist2$0");
	print$mylist2$0(mylist2$0$value);
	printf("\n");
	addr mylist$0$value = alloc(2);
	mylist$0(mylist$0$value);
	printf("value %s = ", "mylist$0");
	print$mylist$0(mylist$0$value);
	printf("\n");
}

