#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <locale.h>


typedef enum tag {
	TAG_cons,
	TAG_extract,
	TAG_false,
	TAG_filter,
	TAG_nil,
	TAG_true
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


void print$bool(addr val$);
void print$list(addr val$);
void print$filter(addr val$);
void lt_helper$0(addr s$80, addr x, addr y, addr leq);
void lt$0(addr s$72, addr x, addr y);
void leq$0(addr s$23, addr x, addr y);
void equal$0(addr s$20, addr x, addr y);
void square$0(addr s$16, addr x);
void mul$0(addr s$13, addr x, addr y);
void sub$0(addr s$10, addr x, addr y);
void pred$0(addr s$7, addr x);
void add$0(addr s$4, addr x, addr y);
void succ$0(addr s$1, addr x);
void print$bool(addr val$) {
switch (val$->tag){
case TAG_true:{
addr val$_TAG_true = (val$+1)->ptr;
printf("'true ");
printf("()");
break;
}
case TAG_false:{
addr val$_TAG_false = (val$+1)->ptr;
printf("'false ");
printf("()");
break;
}
}
}
void print$list(addr val$) {
switch (val$->tag){
case TAG_nil:{
addr val$_TAG_nil = (val$+1)->ptr;
printf("'nil ");
printf("()");
break;
}
case TAG_cons:{
addr val$_TAG_cons = (val$+1)->ptr;
printf("'cons ");
addr val$_TAG_cons_pi1 = val$_TAG_cons->ptr;
addr val$_TAG_cons_pi2 = (val$_TAG_cons+1)->ptr;
printf("(");
addr val$_TAG_cons_pi1_inshift = val$_TAG_cons_pi1->ptr;
printf("<");
printf("%d", val$_TAG_cons_pi1_inshift->i);
printf(">");
printf(", ");
print$list(val$_TAG_cons_pi2);
printf(")");
break;
}
}
}
void print$filter(addr val$) {
printf("clos");
}

void lt_helper$0(addr s$80, addr x, addr y, addr leq) {
	addr s$81 = alloc(2);
	addr s$83 = alloc(2);
	s$83->tag = ((x->i) = (y->i)) ? TAG_true : TAG_false;
	addr _s$83 = NULL;
	s$83->ptr = _s$83;
	s$81->ptr = leq;
	(s$81+1)->ptr = s$83;
	addr n$2 = s$81->ptr;
	addr n$3 = (s$81+1)->ptr;
	switch (n$2->tag){
	case TAG_true:{
		addr n$8 = (n$2+1)->ptr;
		switch (n$3->tag){
		case TAG_true:{
			addr n$15 = (n$3+1)->ptr;
			addr s$99 = alloc(0);
			s$99 = NULL;
			s$80->tag = TAG_false;
			(s$80+1)->ptr = s$99;
			break;
		}

		case TAG_false:{
			addr n$15 = (n$3+1)->ptr;
			addr s$104 = alloc(0);
			s$104 = NULL;
			s$80->tag = TAG_true;
			(s$80+1)->ptr = s$104;
			break;
		}
		}
		break;
	}

	case TAG_false:{
		addr n$8 = (n$2+1)->ptr;
		switch (n$3->tag){
		case TAG_true:{
			addr n$28 = (n$3+1)->ptr;
			addr s$115 = alloc(0);
			s$115 = NULL;
			s$80->tag = TAG_false;
			(s$80+1)->ptr = s$115;
			break;
		}

		case TAG_false:{
			addr n$28 = (n$3+1)->ptr;
			addr s$120 = alloc(0);
			s$120 = NULL;
			s$80->tag = TAG_false;
			(s$80+1)->ptr = s$120;
			break;
		}
		}
		break;
	}
	}
}

void lt$0(addr s$72, addr x, addr y) {
	addr s$76 = alloc(2);
	leq$0(s$76, x, y);
	lt_helper$0(s$72, x, y, s$76);
}

void leq$0(addr s$23, addr x, addr y) {
	addr s$24 = alloc(2);
	addr s$25 = alloc(2);
	addr s$30 = alloc(1);
	s$30->i = 0;
	s$25->tag = ((x->i) = (s$30->i)) ? TAG_true : TAG_false;
	addr _s$25 = NULL;
	s$25->ptr = _s$25;
	addr s$26 = alloc(2);
	addr s$28 = alloc(1);
	s$28->i = 0;
	s$26->tag = ((y->i) = (s$28->i)) ? TAG_true : TAG_false;
	addr _s$26 = NULL;
	s$26->ptr = _s$26;
	s$24->ptr = s$25;
	(s$24+1)->ptr = s$26;
	addr n$38 = s$24->ptr;
	addr n$39 = (s$24+1)->ptr;
	switch (n$38->tag){
	case TAG_true:{
		addr n$44 = (n$38+1)->ptr;
		switch (n$39->tag){
		case TAG_true:{
			addr n$51 = (n$39+1)->ptr;
			addr s$44 = alloc(0);
			s$44 = NULL;
			s$23->tag = TAG_true;
			(s$23+1)->ptr = s$44;
			break;
		}

		case TAG_false:{
			addr n$51 = (n$39+1)->ptr;
			addr s$49 = alloc(0);
			s$49 = NULL;
			s$23->tag = TAG_true;
			(s$23+1)->ptr = s$49;
			break;
		}
		}
		break;
	}

	case TAG_false:{
		addr n$44 = (n$38+1)->ptr;
		switch (n$39->tag){
		case TAG_true:{
			addr n$64 = (n$39+1)->ptr;
			addr s$60 = alloc(0);
			s$60 = NULL;
			s$23->tag = TAG_false;
			(s$23+1)->ptr = s$60;
			break;
		}

		case TAG_false:{
			addr n$64 = (n$39+1)->ptr;
			addr s$66 = alloc(1);
			addr s$71 = alloc(1);
			s$71->i = 1;
			s$66->i = (x->i) - (s$71->i);
			addr s$67 = alloc(1);
			addr s$69 = alloc(1);
			s$69->i = 1;
			s$67->i = (y->i) - (s$69->i);
			leq$0(s$23, s$66, s$67);
			break;
		}
		}
		break;
	}
	}
}

void equal$0(addr s$20, addr x, addr y) {
	s$20->tag = ((x->i) = (y->i)) ? TAG_true : TAG_false;
	addr _s$20 = NULL;
	s$20->ptr = _s$20;
}

void square$0(addr s$16, addr x) {
	mul$0(s$16, x, x);
}

void mul$0(addr s$13, addr x, addr y) {
	s$13->i = (x->i) * (y->i);
}

void sub$0(addr s$10, addr x, addr y) {
	s$10->i = (x->i) - (y->i);
}

void pred$0(addr s$7, addr x) {
	addr s$9 = alloc(1);
	s$9->i = 1;
	s$7->i = (x->i) - (s$9->i);
}

void add$0(addr s$4, addr x, addr y) {
	s$4->i = (x->i) + (y->i);
}

void succ$0(addr s$1, addr x) {
	addr s$3 = alloc(1);
	s$3->i = 1;
	s$1->i = (x->i) + (s$3->i);
}
int main (){
	init_heap(1024 * 1024);
	freopen("test.nd.val", "w", stdout);
}

