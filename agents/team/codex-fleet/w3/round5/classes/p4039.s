# n=5 model=out iset=I1 prefix14_class=4039
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovg P0, S1
mov S2, P2
cmp P3, P2
cmovl P2, P3
mov S0, P2
cmovge S2, P3
cmp P1, P2
cmovle P2, P1
cmovg S0, P1
cmp P0, S2
mov P2, P0
