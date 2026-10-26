# n=5 model=out iset=I1 prefix14_class=903
cmp P1, P3
mov S0, P0
mov S1, P3
cmovg S1, P1
cmovl P3, P1
cmp P0, P2
cmovg S0, P2
mov P1, S1
cmovge P2, P0
mov S2, P3
cmp P2, P1
cmovge S1, P2
cmovle P1, P2
cmp P3, S0
