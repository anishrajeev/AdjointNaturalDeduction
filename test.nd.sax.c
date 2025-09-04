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
static unsigned long env_size;
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
void print$list(addr val$);
void print$bool(addr val$);
void f$0(addr s$210);
void t$0(addr s$204);
void f2s$0(addr s$201);
void f2s$0_1(addr d$0);
void f2$0(addr s$195);
void f2$0_1(addr d$0);
void fl4$0(addr s$188);
void fl3$0(addr s$181);
void l4$0(addr s$174);
void l3$0(addr s$167);
void l2$0(addr s$160);
void l1$0(addr s$153);
void four$0(addr s$150);
void three$0(addr s$147);
void two$0(addr s$144);
void one$0(addr s$141);
void search$1(addr s$82, addr f, addr l);
void search$0(addr s$82, addr f, addr l);
void equal_nat$1(addr s$1, addr x1, addr x2);
void equal_nat$0(addr s$1, addr x1, addr x2);
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
print$nat(val$_TAG_cons_pi1_inshift);
printf(">");
printf(", ");
print$list(val$_TAG_cons_pi2);
printf(")");
break;
}
}
}
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
void print$f$0(addr val$) {
print$bool(val$);
}
void print$t$0(addr val$) {
print$bool(val$);
}
void print$f2s$0(addr val$) {
printf("clos");
}
void print$f2$0(addr val$) {
printf("clos");
}
void print$fl4$0(addr val$) {
print$list(val$);
}
void print$fl3$0(addr val$) {
print$list(val$);
}
void print$l4$0(addr val$) {
print$list(val$);
}
void print$l3$0(addr val$) {
print$list(val$);
}
void print$l2$0(addr val$) {
print$list(val$);
}
void print$l1$0(addr val$) {
print$list(val$);
}
void print$four$0(addr val$) {
print$nat(val$);
}
void print$three$0(addr val$) {
print$nat(val$);
}
void print$two$0(addr val$) {
print$nat(val$);
}
void print$one$0(addr val$) {
print$nat(val$);
}

void f$0(addr s$210) {
	env_size += 2;
	addr s$212 = alloc(2);
	f2s$0(s$212);
	env_size += 2;
	addr s$213 = alloc(2);
	fl4$0(s$213);
	search$1(s$210, s$212, s$213);
}

void t$0(addr s$204) {
	env_size += 2;
	addr s$206 = alloc(2);
	f2s$0(s$206);
	env_size += 2;
	addr s$207 = alloc(2);
	l4$0(s$207);
	search$1(s$204, s$206, s$207);
}

void f2s$0(addr s$201) {
	f2s$0_1(s$201);
}

void f2s$0_1$(addr $params, addr $eta) {
	addr s$202 = $params->ptr;
	f2$0(s$202);
}
void f2s$0_1(addr d$0) {
	d$0->fun = &(f2s$0_1$);
	addr d$0_eta = alloc(0);
	(d$0+1)->env = d$0_eta;
}

void f2$0(addr s$195) {
	f2$0_1(s$195);
}

void f2$0_1$(addr $params, addr $eta) {
	addr x = $params->ptr;
	addr s$196 = ($params+1)->ptr;
	env_size += 2;
	addr s$199 = alloc(2);
	two$0(s$199);
	equal_nat$1(s$196, x, s$199);
}
void f2$0_1(addr d$0) {
	d$0->fun = &(f2$0_1$);
	addr d$0_eta = alloc(0);
	(d$0+1)->env = d$0_eta;
}

void fl4$0(addr s$188) {
	env_size += 2;
	addr s$189 = alloc(2);
	env_size += 1;
	addr s$190 = alloc(1);
	env_size += 2;
	addr s$193 = alloc(2);
	four$0(s$193);
	s$190->ptr = s$193;
	env_size += 2;
	addr s$191 = alloc(2);
	fl3$0(s$191);
	s$189->ptr = s$190;
	(s$189+1)->ptr = s$191;
	s$188->tag = TAG_cons;
	(s$188+1)->ptr = s$189;
}

void fl3$0(addr s$181) {
	env_size += 2;
	addr s$182 = alloc(2);
	env_size += 1;
	addr s$183 = alloc(1);
	env_size += 2;
	addr s$186 = alloc(2);
	three$0(s$186);
	s$183->ptr = s$186;
	env_size += 2;
	addr s$184 = alloc(2);
	l1$0(s$184);
	s$182->ptr = s$183;
	(s$182+1)->ptr = s$184;
	s$181->tag = TAG_cons;
	(s$181+1)->ptr = s$182;
}

void l4$0(addr s$174) {
	env_size += 2;
	addr s$175 = alloc(2);
	env_size += 1;
	addr s$176 = alloc(1);
	env_size += 2;
	addr s$179 = alloc(2);
	four$0(s$179);
	s$176->ptr = s$179;
	env_size += 2;
	addr s$177 = alloc(2);
	l3$0(s$177);
	s$175->ptr = s$176;
	(s$175+1)->ptr = s$177;
	s$174->tag = TAG_cons;
	(s$174+1)->ptr = s$175;
}

void l3$0(addr s$167) {
	env_size += 2;
	addr s$168 = alloc(2);
	env_size += 1;
	addr s$169 = alloc(1);
	env_size += 2;
	addr s$172 = alloc(2);
	three$0(s$172);
	s$169->ptr = s$172;
	env_size += 2;
	addr s$170 = alloc(2);
	l2$0(s$170);
	s$168->ptr = s$169;
	(s$168+1)->ptr = s$170;
	s$167->tag = TAG_cons;
	(s$167+1)->ptr = s$168;
}

void l2$0(addr s$160) {
	env_size += 2;
	addr s$161 = alloc(2);
	env_size += 1;
	addr s$162 = alloc(1);
	env_size += 2;
	addr s$165 = alloc(2);
	two$0(s$165);
	s$162->ptr = s$165;
	env_size += 2;
	addr s$163 = alloc(2);
	l1$0(s$163);
	s$161->ptr = s$162;
	(s$161+1)->ptr = s$163;
	s$160->tag = TAG_cons;
	(s$160+1)->ptr = s$161;
}

void l1$0(addr s$153) {
	env_size += 2;
	addr s$154 = alloc(2);
	env_size += 1;
	addr s$155 = alloc(1);
	env_size += 2;
	addr s$158 = alloc(2);
	one$0(s$158);
	s$155->ptr = s$158;
	env_size += 2;
	addr s$156 = alloc(2);
	env_size += 0;
	addr s$157 = alloc(0);
	s$157 = NULL;
	s$156->tag = TAG_nil;
	(s$156+1)->ptr = s$157;
	s$154->ptr = s$155;
	(s$154+1)->ptr = s$156;
	s$153->tag = TAG_cons;
	(s$153+1)->ptr = s$154;
}

void four$0(addr s$150) {
	env_size += 2;
	addr s$151 = alloc(2);
	three$0(s$151);
	s$150->tag = TAG_succ;
	(s$150+1)->ptr = s$151;
}

void three$0(addr s$147) {
	env_size += 2;
	addr s$148 = alloc(2);
	two$0(s$148);
	s$147->tag = TAG_succ;
	(s$147+1)->ptr = s$148;
}

void two$0(addr s$144) {
	env_size += 2;
	addr s$145 = alloc(2);
	one$0(s$145);
	s$144->tag = TAG_succ;
	(s$144+1)->ptr = s$145;
}

void one$0(addr s$141) {
	env_size += 2;
	addr s$142 = alloc(2);
	env_size += 0;
	addr s$143 = alloc(0);
	s$143 = NULL;
	s$142->tag = TAG_zero;
	(s$142+1)->ptr = s$143;
	s$141->tag = TAG_succ;
	(s$141+1)->ptr = s$142;
}

void search$1(addr s$82, addr f, addr l) {
	switch (l->tag){
	case TAG_nil:{
		addr n$2 = (l+1)->ptr;
		env_size += 0;
		addr s$116 = alloc(0);
		s$116 = NULL;
		s$82->tag = TAG_false;
		(s$82+1)->ptr = s$116;
		break;
	}

	case TAG_cons:{
		addr n$2 = (l+1)->ptr;
		addr n$10 = n$2->ptr;
		addr n$11 = (n$2+1)->ptr;
		addr n$19 = n$10->ptr;
		env_size += 2;
		addr s$128 = alloc(2);
		env_size += 2;
		addr s$129 = alloc(2);
		invoke_closure_susp (f, s$129);
		invoke_closure_fun (s$129, n$19, s$128);
		switch (s$128->tag){
		case TAG_true:{
			addr n$28 = (s$128+1)->ptr;
			env_size += 0;
			addr s$135 = alloc(0);
			s$135 = NULL;
			s$82->tag = TAG_true;
			(s$82+1)->ptr = s$135;
			break;
		}

		case TAG_false:{
			addr n$28 = (s$128+1)->ptr;
			search$1(s$82, f, n$11);
			break;
		}
		}
		break;
	}
	}
}

void search$0(addr s$82, addr f, addr l) {
	switch (l->tag){
	case TAG_nil:{
		addr n$2 = (l+1)->ptr;
		env_size += 0;
		addr s$87 = alloc(0);
		s$87 = NULL;
		s$82->tag = TAG_false;
		(s$82+1)->ptr = s$87;
		break;
	}

	case TAG_cons:{
		addr n$2 = (l+1)->ptr;
		addr n$10 = n$2->ptr;
		addr n$11 = (n$2+1)->ptr;
		addr n$19 = n$10->ptr;
		env_size += 2;
		addr s$99 = alloc(2);
		env_size += 2;
		addr s$100 = alloc(2);
		invoke_closure_susp (f, s$100);
		invoke_closure_fun (s$100, n$19, s$99);
		switch (s$99->tag){
		case TAG_true:{
			addr n$28 = (s$99+1)->ptr;
			env_size += 0;
			addr s$106 = alloc(0);
			s$106 = NULL;
			s$82->tag = TAG_true;
			(s$82+1)->ptr = s$106;
			break;
		}

		case TAG_false:{
			addr n$28 = (s$99+1)->ptr;
			search$0(s$82, f, n$11);
			break;
		}
		}
		break;
	}
	}
}

void equal_nat$1(addr s$1, addr x1, addr x2) {
	env_size += 2;
	addr s$42 = alloc(2);
	s$42->ptr = x1;
	(s$42+1)->ptr = x2;
	addr n$32 = s$42->ptr;
	addr n$33 = (s$42+1)->ptr;
	switch (n$32->tag){
	case TAG_zero:{
		addr n$41 = (n$32+1)->ptr;
		switch (n$33->tag){
		case TAG_zero:{
			addr n$48 = (n$33+1)->ptr;
			env_size += 0;
			addr s$58 = alloc(0);
			s$58 = NULL;
			s$1->tag = TAG_true;
			(s$1+1)->ptr = s$58;
			break;
		}

		case TAG_succ:{
			addr n$48 = (n$33+1)->ptr;
			env_size += 0;
			addr s$63 = alloc(0);
			s$63 = NULL;
			s$1->tag = TAG_false;
			(s$1+1)->ptr = s$63;
			break;
		}
		}
		break;
	}

	case TAG_succ:{
		addr n$41 = (n$32+1)->ptr;
		switch (n$33->tag){
		case TAG_zero:{
			addr n$63 = (n$33+1)->ptr;
			env_size += 0;
			addr s$74 = alloc(0);
			s$74 = NULL;
			s$1->tag = TAG_false;
			(s$1+1)->ptr = s$74;
			break;
		}

		case TAG_succ:{
			addr n$63 = (n$33+1)->ptr;
			equal_nat$1(s$1, n$41, n$63);
			break;
		}
		}
		break;
	}
	}
}

void equal_nat$0(addr s$1, addr x1, addr x2) {
	env_size += 2;
	addr s$2 = alloc(2);
	s$2->ptr = x1;
	(s$2+1)->ptr = x2;
	addr n$32 = s$2->ptr;
	addr n$33 = (s$2+1)->ptr;
	switch (n$32->tag){
	case TAG_zero:{
		addr n$41 = (n$32+1)->ptr;
		switch (n$33->tag){
		case TAG_zero:{
			addr n$48 = (n$33+1)->ptr;
			env_size += 0;
			addr s$18 = alloc(0);
			s$18 = NULL;
			s$1->tag = TAG_true;
			(s$1+1)->ptr = s$18;
			break;
		}

		case TAG_succ:{
			addr n$48 = (n$33+1)->ptr;
			env_size += 0;
			addr s$23 = alloc(0);
			s$23 = NULL;
			s$1->tag = TAG_false;
			(s$1+1)->ptr = s$23;
			break;
		}
		}
		break;
	}

	case TAG_succ:{
		addr n$41 = (n$32+1)->ptr;
		switch (n$33->tag){
		case TAG_zero:{
			addr n$63 = (n$33+1)->ptr;
			env_size += 0;
			addr s$34 = alloc(0);
			s$34 = NULL;
			s$1->tag = TAG_false;
			(s$1+1)->ptr = s$34;
			break;
		}

		case TAG_succ:{
			addr n$63 = (n$33+1)->ptr;
			equal_nat$0(s$1, n$41, n$63);
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
	addr f$0$value = alloc(2);
	f$0(f$0$value);
	printf("value %s = ", "f$0");
	print$f$0(f$0$value);
	printf("\n");
	addr t$0$value = alloc(2);
	t$0(t$0$value);
	printf("value %s = ", "t$0");
	print$t$0(t$0$value);
	printf("\n");
	addr f2s$0$value = alloc(2);
	f2s$0(f2s$0$value);
	printf("value %s = ", "f2s$0");
	print$f2s$0(f2s$0$value);
	printf("\n");
	addr f2$0$value = alloc(2);
	f2$0(f2$0$value);
	printf("value %s = ", "f2$0");
	print$f2$0(f2$0$value);
	printf("\n");
	addr fl4$0$value = alloc(2);
	fl4$0(fl4$0$value);
	printf("value %s = ", "fl4$0");
	print$fl4$0(fl4$0$value);
	printf("\n");
	addr fl3$0$value = alloc(2);
	fl3$0(fl3$0$value);
	printf("value %s = ", "fl3$0");
	print$fl3$0(fl3$0$value);
	printf("\n");
	addr l4$0$value = alloc(2);
	l4$0(l4$0$value);
	printf("value %s = ", "l4$0");
	print$l4$0(l4$0$value);
	printf("\n");
	addr l3$0$value = alloc(2);
	l3$0(l3$0$value);
	printf("value %s = ", "l3$0");
	print$l3$0(l3$0$value);
	printf("\n");
	addr l2$0$value = alloc(2);
	l2$0(l2$0$value);
	printf("value %s = ", "l2$0");
	print$l2$0(l2$0$value);
	printf("\n");
	addr l1$0$value = alloc(2);
	l1$0(l1$0$value);
	printf("value %s = ", "l1$0");
	print$l1$0(l1$0$value);
	printf("\n");
	addr four$0$value = alloc(2);
	four$0(four$0$value);
	printf("value %s = ", "four$0");
	print$four$0(four$0$value);
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
	addr one$0$value = alloc(2);
	one$0(one$0$value);
	printf("value %s = ", "one$0");
	print$one$0(one$0$value);
	printf("\n");
printf("//Total allocations : %d\n", alloc_count);
printf("//Total space : %d\n", alloc_size);
}

