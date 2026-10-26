# n=5 model=out iset=I1 prefix14_class=4782
cmp P0, P2
cmovl S2, P0
cmovle P0, P2
cmovl P2, S2
cmp P1, P3
mov S1, P3
mov S0, P2
cmovg S1, P1
cmovge P1, P3
mov S2, S1
cmp P1, S0
cmovge P2, P1
cmovg P1, S0
mov P1, P2
