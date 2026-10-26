# n=5 model=out iset=I1 prefix14_class=12740
mov S1, P3
cmp P2, P3
cmovl S1, P2
cmovg P3, P2
cmp P0, P1
mov S0, P0
cmovl P0, P1
cmovle P1, S0
cmp P1, S1
cmovge P2, S1
cmovg S1, P1
cmovge P1, P2
cmp P0, P3
mov P1, S1
