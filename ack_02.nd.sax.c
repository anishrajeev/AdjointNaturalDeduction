#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <locale.h>


typedef enum tag {
	TAG_false,
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
void ack_two_two$0(addr s$55);
void ack$0(addr s$31, addr m, addr n);
void add$0(addr s$19, addr a, addr b);
void three$0(addr s$15);
void two$0(addr s$11);
void one$1(addr s$4);
void one$0(addr s$4);
void succ$1(addr s$1, addr n);
void succ$0(addr s$1, addr n);
void print$nat(addr val$) {
switch (val$->tag){
case TAG_zero:{
addr val$_TAG_zero = (val$+1)->ptr;
printf("'zero ");
printf("()");
break;
}
case TAG_succ:{
addr val$_TAG_succ = (val$+1)->ptr;
printf("'succ ");
print$nat(val$_TAG_succ);
break;
}
}
}
void print$ack_two_two$0(addr val$) {
print$nat(val$);
}
void print$three$0(addr val$) {
print$nat(val$);
}
void print$two$0(addr val$) {
print$nat(val$);
}
void print$one$1(addr val$) {
print$nat(val$);
}
void print$one$0(addr val$) {
print$nat(val$);
}

void ack_two_two$0(addr s$55) {
	addr s$57 = alloc(2);
	two$0(s$57);
	addr s$58 = alloc(2);
	two$0(s$58);
	ack$0(s$55, s$57, s$58);
}

void ack$0(addr s$31, addr m, addr n) {
	switch (m->tag){
	case TAG_zero:{
		addr n$2 = (m+1)->ptr;
		s$31->tag = TAG_succ;
		(s$31+1)->ptr = n;
		break;
	}

	case TAG_succ:{
		addr n$2 = (m+1)->ptr;
		switch (n->tag){
		case TAG_zero:{
			addr n$8 = (n+1)->ptr;
			addr s$45 = alloc(2);
			one$0(s$45);
			ack$0(s$31, n$2, s$45);
			break;
		}

		case TAG_succ:{
			addr n$8 = (n+1)->ptr;
			addr s$51 = alloc(2);
			ack$0(s$51, m, n$8);
			ack$0(s$31, n$2, s$51);
			break;
		}
		}
		break;
	}
	}
}

void add$0(addr s$19, addr a, addr b) {
	switch (b->tag){
	case TAG_zero:{
		addr n$14 = (b+1)->ptr;
s$19->tag = a->tag;
(s$19+1)->ptr = (a+1)->ptr;
		s$19 = a;
		break;
	}

	case TAG_succ:{
		addr n$14 = (b+1)->ptr;
		addr s$27 = alloc(2);
		add$0(s$27, a, n$14);
		succ$0(s$19, s$27);
		break;
	}
	}
}

void three$0(addr s$15) {
	addr s$17 = alloc(2);
	two$0(s$17);
	succ$0(s$15, s$17);
}

void two$0(addr s$11) {
	addr s$13 = alloc(2);
	one$0(s$13);
	succ$0(s$11, s$13);
}

void one$1(addr s$4) {
	addr s$9 = alloc(2);
	addr s$10 = alloc(0);
	s$10 = NULL;
	s$9->tag = TAG_zero;
	(s$9+1)->ptr = s$10;
	succ$1(s$4, s$9);
}

void one$0(addr s$4) {
	addr s$6 = alloc(2);
	addr s$7 = alloc(0);
	s$7 = NULL;
	s$6->tag = TAG_zero;
	(s$6+1)->ptr = s$7;
	succ$0(s$4, s$6);
}

void succ$1(addr s$1, addr n) {
	s$1->tag = TAG_succ;
	(s$1+1)->ptr = n;
}

void succ$0(addr s$1, addr n) {
	s$1->tag = TAG_succ;
	(s$1+1)->ptr = n;
}
int main (){
	init_heap(1024 * 1024);
	freopen("ack_02.nd.val", "w", stdout);
	addr ack_two_two$0$value = alloc(2);
	ack_two_two$0(ack_two_two$0$value);
	printf("value %s = ", "ack_two_two$0");
	print$ack_two_two$0(ack_two_two$0$value);
	printf("\n");
	addr three$0$value = alloc(2);
	three$0(three$0$value);
	printf("value %s = ", "three$0");
	print$three$0(three$0$value);
	printf("\n");
	addr two$0$value = alloc(2);
	two$0(two$0$value);
	printf("value %s = ", "two$0");
	print$two$0(two$0$value);
	printf("\n");
	addr one$1$value = alloc(2);
	one$1(one$1$value);
	printf("value %s = ", "one$1");
	print$one$1(one$1$value);
	printf("\n");
	addr one$0$value = alloc(2);
	one$0(one$0$value);
	printf("value %s = ", "one$0");
	print$one$0(one$0$value);
	printf("\n");
}

