#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <locale.h>


typedef enum tag {
	TAG_cons,
	TAG_false,
	TAG_next,
	TAG_nil,
	TAG_s,
	TAG_true,
	TAG_z
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
void print$stream(addr val$);
void print$list(addr val$);
void fib_stream_prefix$0(addr s$165);
void fib_stream$0(addr s$159);
void fib_stream_helper$0(addr s$138, addr a, addr b);
void fib_stream_helper$0_1(addr d$0, addr b, addr a);
void twos_prefix$0(addr s$132);
void twos$0(addr s$126);
void ones$0(addr s$121);
void zeros$0(addr s$117);
void eight$0(addr s$111);
void four$0(addr s$105);
void two$0(addr s$102);
void one$0(addr s$99);
void zero$0(addr s$97);
void cons1$0(addr s$87, addr v, addr p);
void take_stream$0(addr s$66, addr n, addr s);
void const_stream$0(addr s$52, addr n);
void const_stream$0_1(addr d$0, addr n);
void add_stream$0(addr s$24, addr s1, addr s2);
void add_stream$0_1(addr d$0, addr s1, addr s2);
void add_nat$0(addr s$1, addr x, addr y);
void print$nat(addr val$) {
switch (val$->tag){
case TAG_z:{
addr val$_TAG_z = (val$+1)->ptr;
printf("('z");
printf("()");
printf(")");
break;
}
case TAG_s:{
addr val$_TAG_s = (val$+1)->ptr;
printf("('s");
print$nat(val$_TAG_s);
printf(")");
break;
}
}
}
void print$stream(addr val$) {
printf("clos");
}
void print$list(addr val$) {
switch (val$->tag){
case TAG_cons:{
addr val$_TAG_cons = (val$+1)->ptr;
printf("('cons");
addr val$_TAG_cons_pi1 = val$_TAG_cons->ptr;
addr val$_TAG_cons_pi2 = (val$_TAG_cons+1)->ptr;
printf("(");
print$nat(val$_TAG_cons_pi1);
printf(", ");
print$list(val$_TAG_cons_pi2);
printf(")");
printf(")");
break;
}
case TAG_nil:{
addr val$_TAG_nil = (val$+1)->ptr;
printf("('nil");
printf("()");
printf(")");
break;
}
}
}
void print$fib_stream_prefix$0(addr val$) {
addr val$_pi1 = val$->ptr;
addr val$_pi2 = (val$+1)->ptr;
printf("(");
print$list(val$_pi1);
printf(", ");
print$stream(val$_pi2);
printf(")");
}
void print$fib_stream$0(addr val$) {
print$stream(val$);
}
void print$twos_prefix$0(addr val$) {
addr val$_pi1 = val$->ptr;
addr val$_pi2 = (val$+1)->ptr;
printf("(");
print$list(val$_pi1);
printf(", ");
print$stream(val$_pi2);
printf(")");
}
void print$twos$0(addr val$) {
print$stream(val$);
}
void print$ones$0(addr val$) {
print$stream(val$);
}
void print$zeros$0(addr val$) {
print$stream(val$);
}
void print$eight$0(addr val$) {
print$nat(val$);
}
void print$four$0(addr val$) {
print$nat(val$);
}
void print$two$0(addr val$) {
print$nat(val$);
}
void print$one$0(addr val$) {
print$nat(val$);
}
void print$zero$0(addr val$) {
print$nat(val$);
}

void fib_stream_prefix$0(addr s$165) {
	addr s$167 = alloc(2);
	eight$0(s$167);
	addr s$168 = alloc(2);
	fib_stream$0(s$168);
	take_stream$0(s$165, s$167, s$168);
}

void fib_stream$0(addr s$159) {
	addr s$161 = alloc(2);
	zero$0(s$161);
	addr s$162 = alloc(2);
	one$0(s$162);
	fib_stream_helper$0(s$159, s$161, s$162);
}

void fib_stream_helper$0(addr s$138, addr a, addr b) {
	fib_stream_helper$0_1(s$138, b, a);
}

void fib_stream_helper$0_1$(addr $params, addr $eta) {
	addr b = ($eta+0)->ptr;
	addr a = ($eta+1)->ptr;
	tag label$ = $params->tag;
	addr dest$ = ($params+1)->ptr;
	switch (label$) {
	case TAG_next:{
		addr s$139 = dest$;
		addr s$140 = alloc(2);
		s$140->ptr = b;
		(s$140+1)->ptr = b;
		addr n$2 = s$140->ptr;
		addr n$3 = (s$140+1)->ptr;
		addr s$148 = alloc(2);
		add_nat$0(s$148, a, n$2);
		addr s$149 = alloc(2);
		addr s$152 = alloc(2);
		add_nat$0(s$152, a, n$2);
		fib_stream_helper$0(s$149, n$3, s$152);
		s$139->ptr = s$148;
		(s$139+1)->ptr = s$149;
		break;
	}
	}
}
void fib_stream_helper$0_1(addr d$0, addr b, addr a) {
	d$0->fun = &(fib_stream_helper$0_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = b;
	(d$0_eta + 1)->ptr = a;
	(d$0+1)->env = d$0_eta;
}

void twos_prefix$0(addr s$132) {
	addr s$134 = alloc(2);
	four$0(s$134);
	addr s$135 = alloc(2);
	twos$0(s$135);
	take_stream$0(s$132, s$134, s$135);
}

void twos$0(addr s$126) {
	addr s$128 = alloc(2);
	ones$0(s$128);
	addr s$129 = alloc(2);
	ones$0(s$129);
	add_stream$0(s$126, s$128, s$129);
}

void ones$0(addr s$121) {
	addr s$123 = alloc(2);
	addr s$124 = alloc(2);
	addr s$125 = alloc(0);
	s$125 = NULL;
	s$124->tag = TAG_z;
	(s$124+1)->ptr = s$125;
	s$123->tag = TAG_s;
	(s$123+1)->ptr = s$124;
	const_stream$0(s$121, s$123);
}

void zeros$0(addr s$117) {
	addr s$119 = alloc(2);
	addr s$120 = alloc(0);
	s$120 = NULL;
	s$119->tag = TAG_z;
	(s$119+1)->ptr = s$120;
	const_stream$0(s$117, s$119);
}

void eight$0(addr s$111) {
	addr s$113 = alloc(2);
	four$0(s$113);
	addr s$114 = alloc(2);
	four$0(s$114);
	add_nat$0(s$111, s$113, s$114);
}

void four$0(addr s$105) {
	addr s$107 = alloc(2);
	two$0(s$107);
	addr s$108 = alloc(2);
	two$0(s$108);
	add_nat$0(s$105, s$107, s$108);
}

void two$0(addr s$102) {
	addr s$103 = alloc(2);
	one$0(s$103);
	s$102->tag = TAG_s;
	(s$102+1)->ptr = s$103;
}

void one$0(addr s$99) {
	addr s$100 = alloc(2);
	zero$0(s$100);
	s$99->tag = TAG_s;
	(s$99+1)->ptr = s$100;
}

void zero$0(addr s$97) {
	addr s$98 = alloc(0);
	s$98 = NULL;
	s$97->tag = TAG_z;
	(s$97+1)->ptr = s$98;
}

void cons1$0(addr s$87, addr v, addr p) {
	addr n$11 = p->ptr;
	addr n$12 = (p+1)->ptr;
	addr s$92 = alloc(2);
	addr s$94 = alloc(2);
	s$94->ptr = v;
	(s$94+1)->ptr = n$11;
	s$92->tag = TAG_cons;
	(s$92+1)->ptr = s$94;
	s$87->ptr = s$92;
	(s$87+1)->ptr = n$12;
}

void take_stream$0(addr s$66, addr n, addr s) {
	switch (n->tag){
	case TAG_z:{
		addr n$20 = (n+1)->ptr;
		addr s$71 = alloc(2);
		addr s$73 = alloc(0);
		s$73 = NULL;
		s$71->tag = TAG_nil;
		(s$71+1)->ptr = s$73;
		s$66->ptr = s$71;
		(s$66+1)->ptr = s;
		break;
	}

	case TAG_s:{
		addr n$20 = (n+1)->ptr;
		addr s$76 = alloc(2);
		invoke_closure_record (s, TAG_next, s$76);		addr n$26 = s$76->ptr;
		addr n$27 = (s$76+1)->ptr;
		addr s$83 = alloc(2);
		take_stream$0(s$83, n$20, n$27);
		cons1$0(s$66, n$26, s$83);
		break;
	}
	}
}

void const_stream$0(addr s$52, addr n) {
	const_stream$0_1(s$52, n);
}

void const_stream$0_1$(addr $params, addr $eta) {
	addr n = ($eta+0)->ptr;
	tag label$ = $params->tag;
	addr dest$ = ($params+1)->ptr;
	switch (label$) {
	case TAG_next:{
		addr s$53 = dest$;
		addr s$54 = alloc(2);
		s$54->ptr = n;
		(s$54+1)->ptr = n;
		addr n$35 = s$54->ptr;
		addr n$36 = (s$54+1)->ptr;
		addr s$63 = alloc(2);
		const_stream$0(s$63, n$36);
		s$53->ptr = n$35;
		(s$53+1)->ptr = s$63;
		break;
	}
	}
}
void const_stream$0_1(addr d$0, addr n) {
	d$0->fun = &(const_stream$0_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = n;
	(d$0+1)->env = d$0_eta;
}

void add_stream$0(addr s$24, addr s1, addr s2) {
	add_stream$0_1(s$24, s1, s2);
}

void add_stream$0_1$(addr $params, addr $eta) {
	addr s1 = ($eta+0)->ptr;
	addr s2 = ($eta+1)->ptr;
	tag label$ = $params->tag;
	addr dest$ = ($params+1)->ptr;
	switch (label$) {
	case TAG_next:{
		addr s$25 = dest$;
		addr s$26 = alloc(2);
		addr s$27 = alloc(2);
		invoke_closure_record (s1, TAG_next, s$27);		addr s$28 = alloc(2);
		invoke_closure_record (s2, TAG_next, s$28);		s$26->ptr = s$27;
		(s$26+1)->ptr = s$28;
		addr n$44 = s$26->ptr;
		addr n$45 = (s$26+1)->ptr;
		addr n$55 = n$44->ptr;
		addr n$56 = (n$44+1)->ptr;
		addr n$68 = n$45->ptr;
		addr n$69 = (n$45+1)->ptr;
		addr s$44 = alloc(2);
		add_nat$0(s$44, n$55, n$68);
		addr s$45 = alloc(2);
		add_stream$0(s$45, n$56, n$69);
		s$25->ptr = s$44;
		(s$25+1)->ptr = s$45;
		break;
	}
	}
}
void add_stream$0_1(addr d$0, addr s1, addr s2) {
	d$0->fun = &(add_stream$0_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = s1;
	(d$0_eta + 1)->ptr = s2;
	(d$0+1)->env = d$0_eta;
}

void add_nat$0(addr s$1, addr x, addr y) {
	addr s$2 = alloc(2);
	s$2->ptr = x;
	(s$2+1)->ptr = y;
	addr n$81 = s$2->ptr;
	addr n$82 = (s$2+1)->ptr;
	switch (n$81->tag){
	case TAG_z:{
		addr n$88 = (n$81+1)->ptr;
s$1->tag = n$82->tag;
(s$1+1)->ptr = (n$82+1)->ptr;
		s$1 = n$82;
		break;
	}

	case TAG_s:{
		addr n$88 = (n$81+1)->ptr;
		addr s$20 = alloc(2);
		add_nat$0(s$20, n$88, n$82);
		s$1->tag = TAG_s;
		(s$1+1)->ptr = s$20;
		break;
	}
	}
}
int main (){
	init_heap(1024 * 1024);
	freopen("test.nd.val", "w", stdout);
	addr fib_stream_prefix$0$value = alloc(2);
	fib_stream_prefix$0(fib_stream_prefix$0$value);
	printf("value %s = ", "fib_stream_prefix$0");
	print$fib_stream_prefix$0(fib_stream_prefix$0$value);
	printf("\n");
	addr fib_stream$0$value = alloc(2);
	fib_stream$0(fib_stream$0$value);
	printf("value %s = ", "fib_stream$0");
	print$fib_stream$0(fib_stream$0$value);
	printf("\n");
	addr twos_prefix$0$value = alloc(2);
	twos_prefix$0(twos_prefix$0$value);
	printf("value %s = ", "twos_prefix$0");
	print$twos_prefix$0(twos_prefix$0$value);
	printf("\n");
	addr twos$0$value = alloc(2);
	twos$0(twos$0$value);
	printf("value %s = ", "twos$0");
	print$twos$0(twos$0$value);
	printf("\n");
	addr ones$0$value = alloc(2);
	ones$0(ones$0$value);
	printf("value %s = ", "ones$0");
	print$ones$0(ones$0$value);
	printf("\n");
	addr zeros$0$value = alloc(2);
	zeros$0(zeros$0$value);
	printf("value %s = ", "zeros$0");
	print$zeros$0(zeros$0$value);
	printf("\n");
	addr eight$0$value = alloc(2);
	eight$0(eight$0$value);
	printf("value %s = ", "eight$0");
	print$eight$0(eight$0$value);
	printf("\n");
	addr four$0$value = alloc(2);
	four$0(four$0$value);
	printf("value %s = ", "four$0");
	print$four$0(four$0$value);
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
	addr zero$0$value = alloc(2);
	zero$0(zero$0$value);
	printf("value %s = ", "zero$0");
	print$zero$0(zero$0$value);
	printf("\n");
}

