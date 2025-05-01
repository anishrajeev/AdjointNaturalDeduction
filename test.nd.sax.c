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
	TAG_none,
	TAG_some,
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
void print$bool(addr val$);
void print$list(addr val$);
void print$filter(addr val$);
void print$some(addr val$);
void main$0(addr s$447);
void sieve_list_t$0(addr s$443);
void four_all$0(addr s$439);
void zero_t$0(addr s$433);
void four$0(addr s$427);
void two$0(addr s$424);
void one$0(addr s$421);
void primes$0(addr s$411, addr n);
void filter_list$0(addr s$386, addr l, addr f);
void cons_if_some$0(addr s$375, addr x, addr l);
void construct_filter_from_list$0(addr s$353, addr factors);
void filter_for$0(addr s$342, addr n, addr cont);
void filter_for$0_1(addr d$0, addr n, addr cont);
void is_factor_of$0(addr s$317, addr x, addr n);
void is_factor_of$0_1(addr d$0, addr x, addr n);
void is_factor_of$0_1_1(addr d$0, addr x, addr n);
void if$0(addr s$308, addr c, addr then, addr _else);
void bind$0(addr s$298, addr x, addr f);
void some_if$0(addr s$289, addr n, addr cond);
void null_filter$0(addr s$286);
void null_filter$0_1(addr d$0);
void all_list$0(addr s$277, addr n);
void sieve_list$0(addr s$270, addr n);
void sieve_list_helper$0(addr s$260, addr x, addr n);
void sieve_list_helper_helper$0(addr s$233, addr res, addr x, addr n);
void lt$0(addr s$182, addr x, addr y);
void leq$0(addr s$131, addr x, addr y);
void equal$0(addr s$80, addr x, addr y);
void square$0(addr s$76, addr x);
void mul$0(addr s$52, addr x, addr y);
void consume_list$0(addr s$51, addr u, addr res);
void consume_bool$0(addr s$50, addr u, addr res);
void consume_nat$0(addr s$49, addr u, addr res);
void dealloc_nat$0(addr s$40, addr x);
void sub$0(addr s$28, addr x, addr y);
void pred$0(addr s$20, addr x);
void add$0(addr s$3, addr x, addr y);
void succ$0(addr s$1, addr x);
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
print$nat(val$_TAG_cons_pi1_inshift);
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
void print$some(addr val$) {
switch (val$->tag){
case TAG_some:{
addr val$_TAG_some = (val$+1)->ptr;
printf("'some ");
print$nat(val$_TAG_some);
break;
}
case TAG_none:{
addr val$_TAG_none = (val$+1)->ptr;
printf("'none ");
printf("()");
break;
}
}
}
void print$main$0(addr val$) {
print$list(val$);
}
void print$sieve_list_t$0(addr val$) {
print$list(val$);
}
void print$four_all$0(addr val$) {
print$list(val$);
}
void print$zero_t$0(addr val$) {
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
void print$null_filter$0(addr val$) {
printf("clos");
}

void main$0(addr s$447) {
	addr s$449 = alloc(2);
	addr s$451 = alloc(2);
	addr s$459 = alloc(2);
	two$0(s$459);
	addr s$460 = alloc(2);
	two$0(s$460);
	mul$0(s$451, s$459, s$460);
	addr s$452 = alloc(2);
	addr s$454 = alloc(2);
	two$0(s$454);
	addr s$455 = alloc(2);
	two$0(s$455);
	mul$0(s$452, s$454, s$455);
	mul$0(s$449, s$451, s$452);
	primes$0(s$447, s$449);
}

void sieve_list_t$0(addr s$443) {
	addr s$445 = alloc(2);
	four$0(s$445);
	sieve_list$0(s$443, s$445);
}

void four_all$0(addr s$439) {
	addr s$441 = alloc(2);
	four$0(s$441);
	all_list$0(s$439, s$441);
}

void zero_t$0(addr s$433) {
	addr s$435 = alloc(2);
	two$0(s$435);
	addr s$436 = alloc(2);
	addr s$437 = alloc(0);
	s$437 = NULL;
	s$436->tag = TAG_zero;
	(s$436+1)->ptr = s$437;
	mul$0(s$433, s$435, s$436);
}

void four$0(addr s$427) {
	addr s$429 = alloc(2);
	two$0(s$429);
	addr s$430 = alloc(2);
	two$0(s$430);
	mul$0(s$427, s$429, s$430);
}

void two$0(addr s$424) {
	addr s$425 = alloc(2);
	one$0(s$425);
	s$424->tag = TAG_succ;
	(s$424+1)->ptr = s$425;
}

void one$0(addr s$421) {
	addr s$422 = alloc(2);
	addr s$423 = alloc(0);
	s$423 = NULL;
	s$422->tag = TAG_zero;
	(s$422+1)->ptr = s$423;
	s$421->tag = TAG_succ;
	(s$421+1)->ptr = s$422;
}

void primes$0(addr s$411, addr n) {
	addr s$413 = alloc(2);
	all_list$0(s$413, n);
	addr s$414 = alloc(2);
	addr s$416 = alloc(2);
	sieve_list$0(s$416, n);
	construct_filter_from_list$0(s$414, s$416);
	filter_list$0(s$411, s$413, s$414);
}

void filter_list$0(addr s$386, addr l, addr f) {
	switch (l->tag){
	case TAG_nil:{
		addr n$2 = (l+1)->ptr;
		addr s$391 = alloc(0);
		s$391 = NULL;
		s$386->tag = TAG_nil;
		(s$386+1)->ptr = s$391;
		break;
	}

	case TAG_cons:{
		addr n$2 = (l+1)->ptr;
		addr n$10 = n$2->ptr;
		addr n$11 = (n$2+1)->ptr;
		addr n$19 = n$10->ptr;
		addr s$404 = alloc(2);
		invoke_closure_fun (f, n$19, s$404);
		addr s$405 = alloc(2);
		filter_list$0(s$405, n$11, f);
		cons_if_some$0(s$386, s$404, s$405);
		break;
	}
	}
}

void cons_if_some$0(addr s$375, addr x, addr l) {
	switch (x->tag){
	case TAG_some:{
		addr n$28 = (x+1)->ptr;
		addr s$380 = alloc(2);
		addr s$381 = alloc(1);
		s$381->ptr = n$28;
		s$380->ptr = s$381;
		(s$380+1)->ptr = l;
		s$375->tag = TAG_cons;
		(s$375+1)->ptr = s$380;
		break;
	}

	case TAG_none:{
		addr n$28 = (x+1)->ptr;
s$375->tag = l->tag;
(s$375+1)->ptr = (l+1)->ptr;
		s$375 = l;
		break;
	}
	}
}

void construct_filter_from_list$0(addr s$353, addr factors) {
	switch (factors->tag){
	case TAG_nil:{
		addr n$34 = (factors+1)->ptr;
		null_filter$0(s$353);
		break;
	}

	case TAG_cons:{
		addr n$34 = (factors+1)->ptr;
		addr n$42 = n$34->ptr;
		addr n$43 = (n$34+1)->ptr;
		addr n$51 = n$42->ptr;
		addr s$372 = alloc(2);
		construct_filter_from_list$0(s$372, n$43);
		filter_for$0(s$353, n$51, s$372);
		break;
	}
	}
}

void filter_for$0(addr s$342, addr n, addr cont) {
	filter_for$0_1(s$342, n, cont);
}

void filter_for$0_1$(addr $params, addr $eta) {
	addr n = ($eta+0)->ptr;
	addr cont = ($eta+1)->ptr;
	addr x = $params->ptr;
	addr s$343 = ($params+1)->ptr;
	addr s$345 = alloc(2);
	addr s$349 = alloc(2);
	is_factor_of$0(s$349, n, x);
	some_if$0(s$345, n, s$349);
	bind$0(s$343, s$345, cont);
}
void filter_for$0_1(addr d$0, addr n, addr cont) {
	d$0->fun = &(filter_for$0_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = n;
	(d$0_eta + 1)->ptr = cont;
	(d$0+1)->env = d$0_eta;
}

void is_factor_of$0(addr s$317, addr x, addr n) {
	addr s$319 = alloc(2);
	equal$0(s$319, x, n);
	addr s$320 = alloc(2);
	addr s$338 = alloc(0);
	s$338 = NULL;
	s$320->tag = TAG_true;
	(s$320+1)->ptr = s$338;
	addr s$321 = alloc(2);
	is_factor_of$0_1(s$321, x, n);
	if$0(s$317, s$319, s$320, s$321);
}

void is_factor_of$0_1$(addr $params, addr $eta) {
	addr x = ($eta+0)->ptr;
	addr n = ($eta+1)->ptr;
	addr u = $params->ptr;
	addr s$322 = ($params+1)->ptr;
	addr s$324 = alloc(2);
	lt$0(s$324, x, n);
	addr s$325 = alloc(2);
	addr s$334 = alloc(0);
	s$334 = NULL;
	s$325->tag = TAG_false;
	(s$325+1)->ptr = s$334;
	addr s$326 = alloc(2);
	is_factor_of$0_1_1(s$326, x, n);
	if$0(s$322, s$324, s$325, s$326);
}
void is_factor_of$0_1(addr d$0, addr x, addr n) {
	d$0->fun = &(is_factor_of$0_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = x;
	(d$0_eta + 1)->ptr = n;
	(d$0+1)->env = d$0_eta;
}

void is_factor_of$0_1_1$(addr $params, addr $eta) {
	addr x = ($eta+0)->ptr;
	addr n = ($eta+1)->ptr;
	addr u = $params->ptr;
	addr s$327 = ($params+1)->ptr;
	addr s$330 = alloc(2);
	sub$0(s$330, x, n);
	is_factor_of$0(s$327, x, s$330);
}
void is_factor_of$0_1_1(addr d$0, addr x, addr n) {
	d$0->fun = &(is_factor_of$0_1_1$);
	addr d$0_eta = alloc(2);
	(d$0_eta + 0)->ptr = x;
	(d$0_eta + 1)->ptr = n;
	(d$0+1)->env = d$0_eta;
}

void if$0(addr s$308, addr c, addr then, addr _else) {
	switch (c->tag){
	case TAG_true:{
		addr n$60 = (c+1)->ptr;
s$308->tag = then->tag;
(s$308+1)->ptr = (then+1)->ptr;
		s$308 = then;
		break;
	}

	case TAG_false:{
		addr n$60 = (c+1)->ptr;
		addr s$315 = alloc(0);
		s$315 = NULL;
		invoke_closure_fun (_else, s$315, s$308);
		break;
	}
	}
}

void bind$0(addr s$298, addr x, addr f) {
	switch (x->tag){
	case TAG_some:{
		addr n$64 = (x+1)->ptr;
		invoke_closure_fun (f, n$64, s$298);
		break;
	}

	case TAG_none:{
		addr n$64 = (x+1)->ptr;
		addr s$307 = alloc(0);
		s$307 = NULL;
		s$298->tag = TAG_none;
		(s$298+1)->ptr = s$307;
		break;
	}
	}
}

void some_if$0(addr s$289, addr n, addr cond) {
	switch (cond->tag){
	case TAG_true:{
		addr n$70 = (cond+1)->ptr;
		s$289->tag = TAG_some;
		(s$289+1)->ptr = n;
		break;
	}

	case TAG_false:{
		addr n$70 = (cond+1)->ptr;
		addr s$297 = alloc(0);
		s$297 = NULL;
		s$289->tag = TAG_none;
		(s$289+1)->ptr = s$297;
		break;
	}
	}
}

void null_filter$0(addr s$286) {
	null_filter$0_1(s$286);
}

void null_filter$0_1$(addr $params, addr $eta) {
	addr x = $params->ptr;
	addr s$287 = ($params+1)->ptr;
	s$287->tag = TAG_some;
	(s$287+1)->ptr = x;
}
void null_filter$0_1(addr d$0) {
	d$0->fun = &(null_filter$0_1$);
	addr d$0_eta = alloc(0);
	(d$0+1)->env = d$0_eta;
}

void all_list$0(addr s$277, addr n) {
	addr s$279 = alloc(2);
	addr s$283 = alloc(2);
	addr s$284 = alloc(2);
	addr s$285 = alloc(0);
	s$285 = NULL;
	s$284->tag = TAG_zero;
	(s$284+1)->ptr = s$285;
	s$283->tag = TAG_succ;
	(s$283+1)->ptr = s$284;
	s$279->tag = TAG_succ;
	(s$279+1)->ptr = s$283;
	addr s$280 = alloc(2);
	square$0(s$280, n);
	sieve_list_helper$0(s$277, s$279, s$280);
}

void sieve_list$0(addr s$270, addr n) {
	addr s$272 = alloc(2);
	addr s$274 = alloc(2);
	addr s$275 = alloc(2);
	addr s$276 = alloc(0);
	s$276 = NULL;
	s$275->tag = TAG_zero;
	(s$275+1)->ptr = s$276;
	s$274->tag = TAG_succ;
	(s$274+1)->ptr = s$275;
	s$272->tag = TAG_succ;
	(s$272+1)->ptr = s$274;
	sieve_list_helper$0(s$270, s$272, n);
}

void sieve_list_helper$0(addr s$260, addr x, addr n) {
	addr s$262 = alloc(2);
	addr s$266 = alloc(2);
	square$0(s$266, x);
	leq$0(s$262, s$266, n);
	sieve_list_helper_helper$0(s$260, s$262, x, n);
}

void sieve_list_helper_helper$0(addr s$233, addr res, addr x, addr n) {
	switch (res->tag){
	case TAG_true:{
		addr n$74 = (res+1)->ptr;
		addr s$238 = alloc(2);
		addr s$239 = alloc(1);
		s$239->ptr = x;
		addr s$240 = alloc(2);
		addr s$242 = alloc(2);
		succ$0(s$242, x);
		sieve_list_helper$0(s$240, s$242, n);
		s$238->ptr = s$239;
		(s$238+1)->ptr = s$240;
		s$233->tag = TAG_cons;
		(s$233+1)->ptr = s$238;
		break;
	}

	case TAG_false:{
		addr n$74 = (res+1)->ptr;
		addr s$250 = alloc(0);
		dealloc_nat$0(s$250, n);
		addr s$251 = alloc(2);
		addr s$253 = alloc(0);
		dealloc_nat$0(s$253, x);
		addr s$254 = alloc(2);
		addr s$255 = alloc(0);
		s$255 = NULL;
		s$254->tag = TAG_nil;
		(s$254+1)->ptr = s$255;
		consume_list$0(s$251, s$253, s$254);
		consume_list$0(s$233, s$250, s$251);
		break;
	}
	}
}

void lt$0(addr s$182, addr x, addr y) {
	addr s$183 = alloc(2);
	s$183->ptr = x;
	(s$183+1)->ptr = y;
	addr n$78 = s$183->ptr;
	addr n$79 = (s$183+1)->ptr;
	switch (n$78->tag){
	case TAG_zero:{
		addr n$87 = (n$78+1)->ptr;
		switch (n$79->tag){
		case TAG_zero:{
			addr n$94 = (n$79+1)->ptr;
			addr s$199 = alloc(0);
			s$199 = NULL;
			s$182->tag = TAG_false;
			(s$182+1)->ptr = s$199;
			break;
		}

		case TAG_succ:{
			addr n$94 = (n$79+1)->ptr;
			addr s$205 = alloc(0);
			dealloc_nat$0(s$205, n$94);
			addr s$206 = alloc(2);
			addr s$207 = alloc(0);
			s$207 = NULL;
			s$206->tag = TAG_true;
			(s$206+1)->ptr = s$207;
			consume_bool$0(s$182, s$205, s$206);
			break;
		}
		}
		break;
	}

	case TAG_succ:{
		addr n$87 = (n$78+1)->ptr;
		switch (n$79->tag){
		case TAG_zero:{
			addr n$109 = (n$79+1)->ptr;
			addr s$221 = alloc(0);
			dealloc_nat$0(s$221, n$87);
			addr s$222 = alloc(2);
			addr s$223 = alloc(0);
			s$223 = NULL;
			s$222->tag = TAG_false;
			(s$222+1)->ptr = s$223;
			consume_bool$0(s$182, s$221, s$222);
			break;
		}

		case TAG_succ:{
			addr n$109 = (n$79+1)->ptr;
			lt$0(s$182, n$87, n$109);
			break;
		}
		}
		break;
	}
	}
}

void leq$0(addr s$131, addr x, addr y) {
	addr s$132 = alloc(2);
	s$132->ptr = x;
	(s$132+1)->ptr = y;
	addr n$120 = s$132->ptr;
	addr n$121 = (s$132+1)->ptr;
	switch (n$120->tag){
	case TAG_zero:{
		addr n$129 = (n$120+1)->ptr;
		switch (n$121->tag){
		case TAG_zero:{
			addr n$136 = (n$121+1)->ptr;
			addr s$148 = alloc(0);
			s$148 = NULL;
			s$131->tag = TAG_true;
			(s$131+1)->ptr = s$148;
			break;
		}

		case TAG_succ:{
			addr n$136 = (n$121+1)->ptr;
			addr s$154 = alloc(0);
			dealloc_nat$0(s$154, n$136);
			addr s$155 = alloc(2);
			addr s$156 = alloc(0);
			s$156 = NULL;
			s$155->tag = TAG_true;
			(s$155+1)->ptr = s$156;
			consume_bool$0(s$131, s$154, s$155);
			break;
		}
		}
		break;
	}

	case TAG_succ:{
		addr n$129 = (n$120+1)->ptr;
		switch (n$121->tag){
		case TAG_zero:{
			addr n$151 = (n$121+1)->ptr;
			addr s$170 = alloc(0);
			dealloc_nat$0(s$170, n$129);
			addr s$171 = alloc(2);
			addr s$172 = alloc(0);
			s$172 = NULL;
			s$171->tag = TAG_false;
			(s$171+1)->ptr = s$172;
			consume_bool$0(s$131, s$170, s$171);
			break;
		}

		case TAG_succ:{
			addr n$151 = (n$121+1)->ptr;
			leq$0(s$131, n$129, n$151);
			break;
		}
		}
		break;
	}
	}
}

void equal$0(addr s$80, addr x, addr y) {
	addr s$81 = alloc(2);
	s$81->ptr = x;
	(s$81+1)->ptr = y;
	addr n$162 = s$81->ptr;
	addr n$163 = (s$81+1)->ptr;
	switch (n$162->tag){
	case TAG_zero:{
		addr n$171 = (n$162+1)->ptr;
		switch (n$163->tag){
		case TAG_zero:{
			addr n$178 = (n$163+1)->ptr;
			addr s$97 = alloc(0);
			s$97 = NULL;
			s$80->tag = TAG_true;
			(s$80+1)->ptr = s$97;
			break;
		}

		case TAG_succ:{
			addr n$178 = (n$163+1)->ptr;
			addr s$103 = alloc(0);
			dealloc_nat$0(s$103, n$178);
			addr s$104 = alloc(2);
			addr s$105 = alloc(0);
			s$105 = NULL;
			s$104->tag = TAG_false;
			(s$104+1)->ptr = s$105;
			consume_bool$0(s$80, s$103, s$104);
			break;
		}
		}
		break;
	}

	case TAG_succ:{
		addr n$171 = (n$162+1)->ptr;
		switch (n$163->tag){
		case TAG_zero:{
			addr n$193 = (n$163+1)->ptr;
			addr s$119 = alloc(0);
			dealloc_nat$0(s$119, n$171);
			addr s$120 = alloc(2);
			addr s$121 = alloc(0);
			s$121 = NULL;
			s$120->tag = TAG_false;
			(s$120+1)->ptr = s$121;
			consume_bool$0(s$80, s$119, s$120);
			break;
		}

		case TAG_succ:{
			addr n$193 = (n$163+1)->ptr;
			equal$0(s$80, n$171, n$193);
			break;
		}
		}
		break;
	}
	}
}

void square$0(addr s$76, addr x) {
	mul$0(s$76, x, x);
}

void mul$0(addr s$52, addr x, addr y) {
	switch (x->tag){
	case TAG_zero:{
		addr n$204 = (x+1)->ptr;
		addr s$58 = alloc(0);
		dealloc_nat$0(s$58, x);
		addr s$59 = alloc(2);
		addr s$61 = alloc(0);
		dealloc_nat$0(s$61, y);
		addr s$62 = alloc(2);
		addr s$63 = alloc(0);
		s$63 = NULL;
		s$62->tag = TAG_zero;
		(s$62+1)->ptr = s$63;
		consume_nat$0(s$59, s$61, s$62);
		consume_nat$0(s$52, s$58, s$59);
		break;
	}

	case TAG_succ:{
		addr n$204 = (x+1)->ptr;
		addr s$72 = alloc(2);
		mul$0(s$72, n$204, y);
		add$0(s$52, y, s$72);
		break;
	}
	}
}

void consume_list$0(addr s$51, addr u, addr res) {
s$51->tag = res->tag;
(s$51+1)->ptr = (res+1)->ptr;
	s$51 = res;
}

void consume_bool$0(addr s$50, addr u, addr res) {
s$50->tag = res->tag;
(s$50+1)->ptr = (res+1)->ptr;
	s$50 = res;
}

void consume_nat$0(addr s$49, addr u, addr res) {
s$49->tag = res->tag;
(s$49+1)->ptr = (res+1)->ptr;
	s$49 = res;
}

void dealloc_nat$0(addr s$40, addr x) {
	switch (x->tag){
	case TAG_zero:{
		addr n$210 = (x+1)->ptr;
		s$40 = NULL;
		break;
	}

	case TAG_succ:{
		addr n$210 = (x+1)->ptr;
		dealloc_nat$0(s$40, n$210);
		break;
	}
	}
}

void sub$0(addr s$28, addr x, addr y) {
	switch (y->tag){
	case TAG_zero:{
		addr n$216 = (y+1)->ptr;
s$28->tag = x->tag;
(s$28+1)->ptr = (x+1)->ptr;
		s$28 = x;
		break;
	}

	case TAG_succ:{
		addr n$216 = (y+1)->ptr;
		addr s$36 = alloc(2);
		sub$0(s$36, x, n$216);
		pred$0(s$28, s$36);
		break;
	}
	}
}

void pred$0(addr s$20, addr x) {
	switch (x->tag){
	case TAG_zero:{
		addr n$222 = (x+1)->ptr;
		addr s$25 = alloc(0);
		s$25 = NULL;
		s$20->tag = TAG_zero;
		(s$20+1)->ptr = s$25;
		break;
	}

	case TAG_succ:{
		addr n$222 = (x+1)->ptr;
s$20->tag = n$222->tag;
(s$20+1)->ptr = (n$222+1)->ptr;
		s$20 = n$222;
		break;
	}
	}
}

void add$0(addr s$3, addr x, addr y) {
	switch (x->tag){
	case TAG_zero:{
		addr n$228 = (x+1)->ptr;
		addr s$9 = alloc(0);
		dealloc_nat$0(s$9, y);
		consume_nat$0(s$3, s$9, x);
		break;
	}

	case TAG_succ:{
		addr n$228 = (x+1)->ptr;
		addr s$16 = alloc(2);
		add$0(s$16, n$228, y);
		succ$0(s$3, s$16);
		break;
	}
	}
}

void succ$0(addr s$1, addr x) {
	s$1->tag = TAG_succ;
	(s$1+1)->ptr = x;
}
int main (){
	init_heap(1024 * 1024);
	freopen("test.nd.val", "w", stdout);
	addr main$0$value = alloc(2);
	main$0(main$0$value);
	printf("value %s = ", "main$0");
	print$main$0(main$0$value);
	printf("\n");
	addr sieve_list_t$0$value = alloc(2);
	sieve_list_t$0(sieve_list_t$0$value);
	printf("value %s = ", "sieve_list_t$0");
	print$sieve_list_t$0(sieve_list_t$0$value);
	printf("\n");
	addr four_all$0$value = alloc(2);
	four_all$0(four_all$0$value);
	printf("value %s = ", "four_all$0");
	print$four_all$0(four_all$0$value);
	printf("\n");
	addr zero_t$0$value = alloc(2);
	zero_t$0(zero_t$0$value);
	printf("value %s = ", "zero_t$0");
	print$zero_t$0(zero_t$0$value);
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
	addr null_filter$0$value = alloc(2);
	null_filter$0(null_filter$0$value);
	printf("value %s = ", "null_filter$0");
	print$null_filter$0(null_filter$0$value);
	printf("\n");
}

