# n=5 model=out iset=I1 prefix14_class=4838
mov S2, P2
cmp P3, P2
cmovl P2, P3
cmovg S2, P3
cmp P1, P0
mov P3, P1
cmovge P1, P0
cmovge P0, P3
cmp P2, P1
cmovle P3, P1
cmovg P3, P2
cmovl P1, P2
cmp P0, S2
cmovge S0, P0
