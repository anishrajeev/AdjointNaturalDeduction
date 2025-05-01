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
void four_all$0(addr s$132);
void all_list$0(addr s$126, addr n);
void sieve_list_helper$0(addr s$116, addr x, addr n);
void sieve_list_helper_helper$0(addr s$99, addr res, addr x, addr n);
void lt_helper$0(addr s$58, addr x, addr y, addr leq);
void lt$0(addr s$50, addr x, addr y);
void leq$0(addr s$1, addr x, addr y);
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
void print$four_all$0(addr val$) {
print$list(val$);
}

void four_all$0(addr s$132) {
	addr s$134 = alloc(1);
	s$134->i = 4;
	all_list$0(s$132, s$134);
}

void all_list$0(addr s$126, addr n) {
	addr s$128 = alloc(1);
	s$128->i = 2;
	addr s$129 = alloc(1);
	s$129->i = (n->i) * (n->i);
	sieve_list_helper$0(s$126, s$128, s$129);
}

void sieve_list_helper$0(addr s$116, addr x, addr n) {
	addr s$118 = alloc(2);
	addr s$122 = alloc(1);
	s$122->i = (x->i) * (x->i);
	leq$0(s$118, s$122, n);
	sieve_list_helper_helper$0(s$116, s$118, x, n);
}

void sieve_list_helper_helper$0(addr s$99, addr res, addr x, addr n) {
	switch (res->tag){
	case TAG_true:{
		addr n$2 = (res+1)->ptr;
		addr s$104 = alloc(2);
		addr s$105 = alloc(1);
		s$105->ptr = x;
		addr s$106 = alloc(2);
		addr s$108 = alloc(1);
		addr s$111 = alloc(1);
		s$111->i = 1;
		s$108->i = (x->i) + (s$111->i);
		sieve_list_helper$0(s$106, s$108, n);
		s$104->ptr = s$105;
		(s$104+1)->ptr = s$106;
		s$99->tag = TAG_cons;
		(s$99+1)->ptr = s$104;
		break;
	}

	case TAG_false:{
		addr n$2 = (res+1)->ptr;
		addr s$115 = alloc(0);
		s$115 = NULL;
		s$99->tag = TAG_nil;
		(s$99+1)->ptr = s$115;
		break;
	}
	}
}

void lt_helper$0(addr s$58, addr x, addr y, addr leq) {
	addr s$59 = alloc(2);
	addr s$61 = alloc(2);
	s$61->tag = ((x->i) == (y->i)) ? TAG_true : TAG_false;
	s$59->ptr = leq;
	(s$59+1)->ptr = s$61;
	addr n$6 = s$59->ptr;
	addr n$7 = (s$59+1)->ptr;
	switch (n$6->tag){
	case TAG_true:{
		addr n$12 = (n$6+1)->ptr;
		switch (n$7->tag){
		case TAG_true:{
			addr n$19 = (n$7+1)->ptr;
			addr s$77 = alloc(0);
			s$77 = NULL;
			s$58->tag = TAG_false;
			(s$58+1)->ptr = s$77;
			break;
		}

		case TAG_false:{
			addr n$19 = (n$7+1)->ptr;
			addr s$82 = alloc(0);
			s$82 = NULL;
			s$58->tag = TAG_true;
			(s$58+1)->ptr = s$82;
			break;
		}
		}
		break;
	}

	case TAG_false:{
		addr n$12 = (n$6+1)->ptr;
		switch (n$7->tag){
		case TAG_true:{
			addr n$32 = (n$7+1)->ptr;
			addr s$93 = alloc(0);
			s$93 = NULL;
			s$58->tag = TAG_false;
			(s$58+1)->ptr = s$93;
			break;
		}

		case TAG_false:{
			addr n$32 = (n$7+1)->ptr;
			addr s$98 = alloc(0);
			s$98 = NULL;
			s$58->tag = TAG_false;
			(s$58+1)->ptr = s$98;
			break;
		}
		}
		break;
	}
	}
}

void lt$0(addr s$50, addr x, addr y) {
	addr s$54 = alloc(2);
	leq$0(s$54, x, y);
	lt_helper$0(s$50, x, y, s$54);
}

void leq$0(addr s$1, addr x, addr y) {
	addr s$2 = alloc(2);
	addr s$3 = alloc(2);
	addr s$8 = alloc(1);
	s$8->i = 0;
	s$3->tag = ((x->i) == (s$8->i)) ? TAG_true : TAG_false;
	addr s$4 = alloc(2);
	addr s$6 = alloc(1);
	s$6->i = 0;
	s$4->tag = ((y->i) == (s$6->i)) ? TAG_true : TAG_false;
	s$2->ptr = s$3;
	(s$2+1)->ptr = s$4;
	addr n$42 = s$2->ptr;
	addr n$43 = (s$2+1)->ptr;
	switch (n$42->tag){
	case TAG_true:{
		addr n$48 = (n$42+1)->ptr;
		switch (n$43->tag){
		case TAG_true:{
			addr n$55 = (n$43+1)->ptr;
			addr s$22 = alloc(0);
			s$22 = NULL;
			s$1->tag = TAG_true;
			(s$1+1)->ptr = s$22;
			break;
		}

		case TAG_false:{
			addr n$55 = (n$43+1)->ptr;
			addr s$27 = alloc(0);
			s$27 = NULL;
			s$1->tag = TAG_true;
			(s$1+1)->ptr = s$27;
			break;
		}
		}
		break;
	}

	case TAG_false:{
		addr n$48 = (n$42+1)->ptr;
		switch (n$43->tag){
		case TAG_true:{
			addr n$68 = (n$43+1)->ptr;
			addr s$38 = alloc(0);
			s$38 = NULL;
			s$1->tag = TAG_false;
			(s$1+1)->ptr = s$38;
			break;
		}

		case TAG_false:{
			addr n$68 = (n$43+1)->ptr;
			addr s$44 = alloc(1);
			addr s$49 = alloc(1);
			s$49->i = 1;
			s$44->i = (x->i) - (s$49->i);
			addr s$45 = alloc(1);
			addr s$47 = alloc(1);
			s$47->i = 1;
			s$45->i = (y->i) - (s$47->i);
			leq$0(s$1, s$44, s$45);
			break;
		}
		}
		break;
	}
	}
}
int main (){
	init_heap(1024 * 1024);
	freopen("test.nd.val", "w", stdout);
	addr four_all$0$value = alloc(2);
	four_all$0(four_all$0$value);
	printf("value %s = ", "four_all$0");
	print$four_all$0(four_all$0$value);
	printf("\n");
}

