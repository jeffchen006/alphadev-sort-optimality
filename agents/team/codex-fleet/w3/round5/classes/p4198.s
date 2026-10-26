# n=5 model=out iset=I1 prefix14_class=4198
cmp P3, P0
mov S0, P0
cmovg S0, P3
cmovg P3, P0
cmovl P0, P3
mov S1, P1
cmp S1, P2
cmovl P1, P2
cmovl P2, S1
cmp P2, P3
cmovle P3, P2
cmovge P0, P2
mov P3, S0
mov P2, P0
