# n=5 model=out iset=I1 prefix14_class=2015
cmp P2, P1
cmovg S0, P1
cmovge P1, P2
cmovg P2, S0
cmp P0, P3
mov S1, P0
cmovg S1, P3
cmovl P0, P3
mov P3, P0
cmp P1, P3
cmovge P3, P1
cmovge P1, P0
mov P0, S1
cmp P2, P0
