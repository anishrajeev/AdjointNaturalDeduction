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
void print$suspense(addr val$);
void print$also_suspended(addr val$);
void print$broader_suspense(addr val$);
void print$normal_suspended(addr val$);
void test2fin$0(addr s$230);
void test2out$0(addr s$226);
void test2out$0_1(addr d$0);
void test2$0(addr s$211);
void test2$0_1(addr d$0);
void test$0(addr s$197);
void test$0_1(addr d$0);
void bfrom$0(addr s$180, addr s);
void bfrom$0_1(addr d$0, addr s);
void die2$3(addr s$167, addr y, addr s);
void die2$2(addr s$167, addr y, addr s);
void die2$1(addr s$167, addr y, addr s);
void die2$0(addr s$167, addr y, addr s);
void bto$1(addr s$144, addr c);
void bto$1_1(addr d$0, addr n$24, addr n$25);
void bto$0(addr s$144, addr c);
void bto$0_1(addr d$0, addr n$24, addr n$25);
void from2$3(addr s$87, addr s);
void from2$3_1(addr d$0, addr s);
void from2$2(addr s$87, addr s);
void from2$2_1(addr d$0, addr s);
void from2$1(addr s$87, addr s);
void from2$1_1(addr d$0, addr s);
void from2$0(addr s$87, addr s);
void from2$0_1(addr d$0, addr s);
void die$3(addr s$74, addr y, addr s);
void die$2(addr s$74, addr y, addr s);
void die$1(addr s$74, addr y, addr s);
void die$0(addr s$74, addr y, addr s);
void from$1(addr s$59, addr s);
void from$1_1(addr d$0, addr s);
void from$0(addr s$59, addr s);
void from$0_1(addr d$0, addr s);
void to2$3(addr s$30, addr c);
void to2$3_1(addr d$0, addr c);
void to2$2(addr s$30, addr c);
void to2$2_1(addr d$0, addr c);
void to2$1(addr s$30, addr c);
void to2$1_1(addr d$0, addr c);
void to2$0(addr s$30, addr c);
void to2$0_1(addr d$0, addr c);
void to$3(addr s$1, addr c);
void to$3_1(addr d$0, addr n$52, addr n$53);
void to$2(addr s$1, addr c);
void to$2_1(addr d$0, addr n$52, addr n$53);
void to$1(addr s$1, addr c);
void to$1_1(addr d$0, addr n$52, addr n$53);
void to$0(addr s$1, addr c);
void to$0_1(addr d$0, addr n$52, addr n$53);
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
void print$suspense(addr val$) {
addr val$_pi1 = val$->ptr;
addr val$_pi2 = (val$+1)->ptr;
printf("(");
print$nat(val$_pi1);
printf(", ");
printf("clos");
printf(")");
}
void print$also_suspended(addr val$) {
printf("clos");
}
void print$broader_suspense(addr val$) {
addr val$_inshift = val$->ptr;
printf("<");
addr val$_inshift_pi1 = val$_inshift->ptr;
addr val$_inshift_pi2 = (val$_inshift+1)->ptr;
printf("(");
print$nat(val$_inshift_pi1);
printf(", ");
printf("clos");
printf(")");
printf(">");
}
void print$normal_suspended(addr val$) {
addr val$_inshift = val$->ptr;
printf("<");
printf("clos");
printf(">");
}
void print$test2fin$0(addr val$) {
print$nat(val$);
}
void print$test2out$0(addr val$) {
printf("clos");
}
void print$test2$0(addr val$) {
addr val$_inshift = val$->ptr;
printf("<");
printf("clos");
printf(">");
}
void print$test$0(addr val$) {
print$nat(val$);
}

void test2fin$0(addr s$230) {
	addr s$231 = alloc(2);
	test2out$0(s$231);
	addr s$232 = alloc(1);
	test2$0(s$232);
	invoke_closure_fun (s$231, s$232, s$230);
}

void test2out$0(addr s$226) {
	test2out$0_1(s$226);
}

void test2out$0_1$(addr $params, addr $eta) {
	addr x = $params->ptr;
	addr s$227 = ($params+1)->ptr;
	addr n$2 = x->ptr;
	invoke_closure_susp (n$2, s$227);
}
void test2out$0_1(addr d$0) {
	d$0->fun = &(test2out$0_1$);
	addr d$0_eta = alloc(0);
	(d$0+1)->env = d$0_eta;
}

void test2$0(addr s$211) {
	addr s$213 = alloc(1);
	addr s$215 = alloc(1);
	addr s$217 = alloc(1);
	addr s$218 = alloc(2);
	addr s$219 = alloc(2);
	addr s$225 = alloc(0);
	s$225 = NULL;
	s$219->tag = TAG_zero;
	(s$219+1)->ptr = s$225;
	addr s$220 = alloc(2);
	test2$0_1(s$220);
	s$218->ptr = s$219;
	(s$218+1)->ptr = s$220;
	s$217->ptr = s$218;
	bto$1(s$215, s$217);
	bfrom$0(s$213, s$215);
	bto$1(s$211, s$213);
}

void test2$0_1$(addr $params, addr $eta) {
	addr z = $params->ptr;
	addr s$221 = ($params+1)->ptr;
	addr s$222 = alloc(2);
	addr s$223 = alloc(2);
	s$223->tag = TAG_succ;
	(s$223+1)->ptr = z;
	s$222->tag = TAG_succ;
	(s$222+1)->ptr = s$223;
	s$221->tag = TAG_succ;
	(s$221+1)->ptr = s$222;
}
void test2$0_1(addr d$0) {
	d$0->fun = &(test2$0_1$);
	addr d$0_eta = alloc(0);
	(d$0+1)->env = d$0_eta;
}

void test$0(addr s$197) {
	addr s$200 = alloc(2);
	addr s$202 = alloc(2);
	addr s$204 = alloc(2);
	addr s$205 = alloc(2);
	addr s$210 = alloc(0);
	s$210 = NULL;
	s$205->tag = TAG_zero;
	(s$205+1)->ptr = s$210;
	addr s$206 = alloc(2);
	test$0_1(s$206);
	s$204->ptr = s$205;
	(s$204+1)->ptr = s$206;
	to2$0(s$202, s$204);
	from2$0(s$200, s$202);
	addr s$198 = alloc(2);
	to$0(s$198, s$200);
	invoke_closure_susp (s$198, s$197);
}

void test$0_1$(addr $params, addr $eta) {
	addr z = $params->ptr;
	addr s$207 = ($params+1)->ptr;
	addr s$208 = alloc(2);
	s$208->tag = TAG_succ;
	(s$208+1)->ptr = z;
	s$207->tag = TAG_succ;
	(s$207+1)->ptr = s$208;
}
void test$0_1(addr d$0) {
	d$0->fun = &(test$0_1$);
	addr d$0_eta = alloc(0);
	(d$0+1)->env = d$0_eta;
}

void bfrom$0(addr s$180, addr s) {
	addr s$181 = alloc(2);
	addr s$182 = alloc(2);
	addr s$196 = alloc(0);
	s$196 = NULL;
	s$182->tag = TAG_zero;
	(s$182+1)->ptr = s$196;
	addr s$183 = alloc(2);
	bfrom$0_1(s$183, s);
	s$181->ptr = s$182;
	(s$181+1)->ptr = s$183;
	s$180->ptr = s$181;
}

void bfrom$0_1$(addr $params, addr $eta) {
	addr s = ($eta+0)->ptr;
	addr n = $params->ptr;
	addr s$184 = ($params+1)->ptr;
	switch (n->tag){
	case TAG_zero:{
		addr n$7 = (n+1)->ptr;
		addr n$11 = s->ptr;
		invoke_closure_susp (n$11, s$184);
		break;
	}

	case TAG_succ:{
		addr n$7 = (n+1)->ptr;
		die2$0(s$184, n$7, s);
		break;
	}
	}
}
void bfrom$0_1(addr d$0, addr s) {
	d$0->fun = &(bfrom$0_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = s;
	(d$0+1)->env = d$0_eta;
}

void die2$3(addr s$167, addr y, addr s) {
	die2$3(s$167, y, s);
}

void die2$2(addr s$167, addr y, addr s) {
	die2$2(s$167, y, s);
}

void die2$1(addr s$167, addr y, addr s) {
	die2$1(s$167, y, s);
}

void die2$0(addr s$167, addr y, addr s) {
	die2$0(s$167, y, s);
}

void bto$1(addr s$144, addr c) {
	addr n$18 = c->ptr;
	addr n$24 = n$18->ptr;
	addr n$25 = (n$18+1)->ptr;
	addr s$163 = alloc(2);
	bto$1_1(s$163, n$24, n$25);
	s$144->ptr = s$163;
}

void bto$1_1$(addr $params, addr $eta) {
	addr n$24 = ($eta+0)->ptr;
	addr n$25 = ($eta+1)->ptr;
	addr s$164 = $params->ptr;
	invoke_closure_fun (n$25, n$24, s$164);
}
void bto$1_1(addr d$0, addr n$24, addr n$25) {
	d$0->fun = &(bto$1_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = n$24;
	(d$0_eta + 1)->ptr = n$25;
	(d$0+1)->env = d$0_eta;
}

void bto$0(addr s$144, addr c) {
	addr n$18 = c->ptr;
	addr n$24 = n$18->ptr;
	addr n$25 = (n$18+1)->ptr;
	addr s$152 = alloc(2);
	bto$0_1(s$152, n$24, n$25);
	s$144->ptr = s$152;
}

void bto$0_1$(addr $params, addr $eta) {
	addr n$24 = ($eta+0)->ptr;
	addr n$25 = ($eta+1)->ptr;
	addr s$153 = $params->ptr;
	invoke_closure_fun (n$25, n$24, s$153);
}
void bto$0_1(addr d$0, addr n$24, addr n$25) {
	d$0->fun = &(bto$0_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = n$24;
	(d$0_eta + 1)->ptr = n$25;
	(d$0+1)->env = d$0_eta;
}

void from2$3(addr s$87, addr s) {
	addr s$130 = alloc(2);
	addr s$143 = alloc(0);
	s$143 = NULL;
	s$130->tag = TAG_zero;
	(s$130+1)->ptr = s$143;
	addr s$131 = alloc(2);
	from2$3_1(s$131, s);
	s$87->ptr = s$130;
	(s$87+1)->ptr = s$131;
}

void from2$3_1$(addr $params, addr $eta) {
	addr s = ($eta+0)->ptr;
	addr n = $params->ptr;
	addr s$132 = ($params+1)->ptr;
	switch (n->tag){
	case TAG_zero:{
		addr n$37 = (n+1)->ptr;
		invoke_closure_susp (s, s$132);
		break;
	}

	case TAG_succ:{
		addr n$37 = (n+1)->ptr;
		die$2(s$132, n$37, s);
		break;
	}
	}
}
void from2$3_1(addr d$0, addr s) {
	d$0->fun = &(from2$3_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = s;
	(d$0+1)->env = d$0_eta;
}

void from2$2(addr s$87, addr s) {
	addr s$116 = alloc(2);
	addr s$129 = alloc(0);
	s$129 = NULL;
	s$116->tag = TAG_zero;
	(s$116+1)->ptr = s$129;
	addr s$117 = alloc(2);
	from2$2_1(s$117, s);
	s$87->ptr = s$116;
	(s$87+1)->ptr = s$117;
}

void from2$2_1$(addr $params, addr $eta) {
	addr s = ($eta+0)->ptr;
	addr n = $params->ptr;
	addr s$118 = ($params+1)->ptr;
	switch (n->tag){
	case TAG_zero:{
		addr n$37 = (n+1)->ptr;
		invoke_closure_susp (s, s$118);
		break;
	}

	case TAG_succ:{
		addr n$37 = (n+1)->ptr;
		die$1(s$118, n$37, s);
		break;
	}
	}
}
void from2$2_1(addr d$0, addr s) {
	d$0->fun = &(from2$2_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = s;
	(d$0+1)->env = d$0_eta;
}

void from2$1(addr s$87, addr s) {
	addr s$102 = alloc(2);
	addr s$115 = alloc(0);
	s$115 = NULL;
	s$102->tag = TAG_zero;
	(s$102+1)->ptr = s$115;
	addr s$103 = alloc(2);
	from2$1_1(s$103, s);
	s$87->ptr = s$102;
	(s$87+1)->ptr = s$103;
}

void from2$1_1$(addr $params, addr $eta) {
	addr s = ($eta+0)->ptr;
	addr n = $params->ptr;
	addr s$104 = ($params+1)->ptr;
	switch (n->tag){
	case TAG_zero:{
		addr n$37 = (n+1)->ptr;
		invoke_closure_susp (s, s$104);
		break;
	}

	case TAG_succ:{
		addr n$37 = (n+1)->ptr;
		die$3(s$104, n$37, s);
		break;
	}
	}
}
void from2$1_1(addr d$0, addr s) {
	d$0->fun = &(from2$1_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = s;
	(d$0+1)->env = d$0_eta;
}

void from2$0(addr s$87, addr s) {
	addr s$88 = alloc(2);
	addr s$101 = alloc(0);
	s$101 = NULL;
	s$88->tag = TAG_zero;
	(s$88+1)->ptr = s$101;
	addr s$89 = alloc(2);
	from2$0_1(s$89, s);
	s$87->ptr = s$88;
	(s$87+1)->ptr = s$89;
}

void from2$0_1$(addr $params, addr $eta) {
	addr s = ($eta+0)->ptr;
	addr n = $params->ptr;
	addr s$90 = ($params+1)->ptr;
	switch (n->tag){
	case TAG_zero:{
		addr n$37 = (n+1)->ptr;
		invoke_closure_susp (s, s$90);
		break;
	}

	case TAG_succ:{
		addr n$37 = (n+1)->ptr;
		die$0(s$90, n$37, s);
		break;
	}
	}
}
void from2$0_1(addr d$0, addr s) {
	d$0->fun = &(from2$0_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = s;
	(d$0+1)->env = d$0_eta;
}

void die$3(addr s$74, addr y, addr s) {
	die$3(s$74, y, s);
}

void die$2(addr s$74, addr y, addr s) {
	die$2(s$74, y, s);
}

void die$1(addr s$74, addr y, addr s) {
	die$1(s$74, y, s);
}

void die$0(addr s$74, addr y, addr s) {
	die$0(s$74, y, s);
}

void from$1(addr s$59, addr s) {
	addr s$67 = alloc(2);
	addr s$71 = alloc(2);
	addr s$72 = alloc(2);
	addr s$73 = alloc(0);
	s$73 = NULL;
	s$72->tag = TAG_zero;
	(s$72+1)->ptr = s$73;
	s$71->tag = TAG_succ;
	(s$71+1)->ptr = s$72;
	s$67->tag = TAG_succ;
	(s$67+1)->ptr = s$71;
	addr s$68 = alloc(2);
	from$1_1(s$68, s);
	s$59->ptr = s$67;
	(s$59+1)->ptr = s$68;
}

void from$1_1$(addr $params, addr $eta) {
	addr s = ($eta+0)->ptr;
	addr n = $params->ptr;
	addr s$69 = ($params+1)->ptr;
	invoke_closure_susp (s, s$69);
}
void from$1_1(addr d$0, addr s) {
	d$0->fun = &(from$1_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = s;
	(d$0+1)->env = d$0_eta;
}

void from$0(addr s$59, addr s) {
	addr s$60 = alloc(2);
	addr s$64 = alloc(2);
	addr s$65 = alloc(2);
	addr s$66 = alloc(0);
	s$66 = NULL;
	s$65->tag = TAG_zero;
	(s$65+1)->ptr = s$66;
	s$64->tag = TAG_succ;
	(s$64+1)->ptr = s$65;
	s$60->tag = TAG_succ;
	(s$60+1)->ptr = s$64;
	addr s$61 = alloc(2);
	from$0_1(s$61, s);
	s$59->ptr = s$60;
	(s$59+1)->ptr = s$61;
}

void from$0_1$(addr $params, addr $eta) {
	addr s = ($eta+0)->ptr;
	addr n = $params->ptr;
	addr s$62 = ($params+1)->ptr;
	invoke_closure_susp (s, s$62);
}
void from$0_1(addr d$0, addr s) {
	d$0->fun = &(from$0_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = s;
	(d$0+1)->env = d$0_eta;
}

void to2$3(addr s$30, addr c) {
	to2$3_1(s$30, c);
}

void to2$3_1$(addr $params, addr $eta) {
	addr c = ($eta+0)->ptr;
	addr s$52 = $params->ptr;
	addr n$43 = c->ptr;
	addr n$44 = (c+1)->ptr;
	invoke_closure_fun (n$44, n$43, s$52);
}
void to2$3_1(addr d$0, addr c) {
	d$0->fun = &(to2$3_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = c;
	(d$0+1)->env = d$0_eta;
}

void to2$2(addr s$30, addr c) {
	to2$2_1(s$30, c);
}

void to2$2_1$(addr $params, addr $eta) {
	addr c = ($eta+0)->ptr;
	addr s$45 = $params->ptr;
	addr n$43 = c->ptr;
	addr n$44 = (c+1)->ptr;
	invoke_closure_fun (n$44, n$43, s$45);
}
void to2$2_1(addr d$0, addr c) {
	d$0->fun = &(to2$2_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = c;
	(d$0+1)->env = d$0_eta;
}

void to2$1(addr s$30, addr c) {
	to2$1_1(s$30, c);
}

void to2$1_1$(addr $params, addr $eta) {
	addr c = ($eta+0)->ptr;
	addr s$38 = $params->ptr;
	addr n$43 = c->ptr;
	addr n$44 = (c+1)->ptr;
	invoke_closure_fun (n$44, n$43, s$38);
}
void to2$1_1(addr d$0, addr c) {
	d$0->fun = &(to2$1_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = c;
	(d$0+1)->env = d$0_eta;
}

void to2$0(addr s$30, addr c) {
	to2$0_1(s$30, c);
}

void to2$0_1$(addr $params, addr $eta) {
	addr c = ($eta+0)->ptr;
	addr s$31 = $params->ptr;
	addr n$43 = c->ptr;
	addr n$44 = (c+1)->ptr;
	invoke_closure_fun (n$44, n$43, s$31);
}
void to2$0_1(addr d$0, addr c) {
	d$0->fun = &(to2$0_1$);
	addr d$0_eta = alloc(1);
	(d$0_eta + 0)->ptr = c;
	(d$0+1)->env = d$0_eta;
}

void to$3(addr s$1, addr c) {
	addr n$52 = c->ptr;
	addr n$53 = (c+1)->ptr;
	to$3_1(s$1, n$52, n$53);
}

void to$3_1$(addr $params, addr $eta) {
	addr n$52 = ($eta+0)->ptr;
	addr n$53 = ($eta+1)->ptr;
	addr s$27 = $params->ptr;
	invoke_closure_fun (n$53, n$52, s$27);
}
void to$3_1(addr d$0, addr n$52, addr n$53) {
	d$0->fun = &(to$3_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = n$52;
	(d$0_eta + 1)->ptr = n$53;
	(d$0+1)->env = d$0_eta;
}

void to$2(addr s$1, addr c) {
	addr n$52 = c->ptr;
	addr n$53 = (c+1)->ptr;
	to$2_1(s$1, n$52, n$53);
}

void to$2_1$(addr $params, addr $eta) {
	addr n$52 = ($eta+0)->ptr;
	addr n$53 = ($eta+1)->ptr;
	addr s$20 = $params->ptr;
	invoke_closure_fun (n$53, n$52, s$20);
}
void to$2_1(addr d$0, addr n$52, addr n$53) {
	d$0->fun = &(to$2_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = n$52;
	(d$0_eta + 1)->ptr = n$53;
	(d$0+1)->env = d$0_eta;
}

void to$1(addr s$1, addr c) {
	addr n$52 = c->ptr;
	addr n$53 = (c+1)->ptr;
	to$1_1(s$1, n$52, n$53);
}

void to$1_1$(addr $params, addr $eta) {
	addr n$52 = ($eta+0)->ptr;
	addr n$53 = ($eta+1)->ptr;
	addr s$13 = $params->ptr;
	invoke_closure_fun (n$53, n$52, s$13);
}
void to$1_1(addr d$0, addr n$52, addr n$53) {
	d$0->fun = &(to$1_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = n$52;
	(d$0_eta + 1)->ptr = n$53;
	(d$0+1)->env = d$0_eta;
}

void to$0(addr s$1, addr c) {
	addr n$52 = c->ptr;
	addr n$53 = (c+1)->ptr;
	to$0_1(s$1, n$52, n$53);
}

void to$0_1$(addr $params, addr $eta) {
	addr n$52 = ($eta+0)->ptr;
	addr n$53 = ($eta+1)->ptr;
	addr s$6 = $params->ptr;
	invoke_closure_fun (n$53, n$52, s$6);
}
void to$0_1(addr d$0, addr n$52, addr n$53) {
	d$0->fun = &(to$0_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = n$52;
	(d$0_eta + 1)->ptr = n$53;
	(d$0+1)->env = d$0_eta;
}
int main (){
	init_heap(1024 * 1024);
	freopen("test.nd.val", "w", stdout);
	addr test2fin$0$value = alloc(2);
	test2fin$0(test2fin$0$value);
	printf("value %s = ", "test2fin$0");
	print$test2fin$0(test2fin$0$value);
	printf("\n");
	addr test2out$0$value = alloc(2);
	test2out$0(test2out$0$value);
	printf("value %s = ", "test2out$0");
	print$test2out$0(test2out$0$value);
	printf("\n");
	addr test2$0$value = alloc(1);
	test2$0(test2$0$value);
	printf("value %s = ", "test2$0");
	print$test2$0(test2$0$value);
	printf("\n");
	addr test$0$value = alloc(2);
	test$0(test$0$value);
	printf("value %s = ", "test$0");
	print$test$0(test$0$value);
	printf("\n");
}

