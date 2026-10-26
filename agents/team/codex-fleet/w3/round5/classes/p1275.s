# n=5 model=out iset=I1 prefix14_class=1275
cmp P1, P2
mov S1, P1
mov S2, P0
cmovle P1, P2
cmovg S1, P2
cmovg P2, P1
cmp P0, P3
cmovl P0, P3
cmovl P3, S2
cmp P2, P0
cmovge P1, P0
cmovle P2, P0
mov S0, P1
mov P0, S1
