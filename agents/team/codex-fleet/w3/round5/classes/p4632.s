# n=5 model=out iset=I1 prefix14_class=4632
mov S0, P3
mov S1, P0
cmp P1, S1
cmovl P0, P1
cmovg S1, P1
cmp P2, S0
cmovl P3, P2
cmovle P2, S0
mov S2, P2
cmp P2, S1
cmovg S2, S1
cmovl P2, S1
cmp P0, P3
cmovge P1, P3
