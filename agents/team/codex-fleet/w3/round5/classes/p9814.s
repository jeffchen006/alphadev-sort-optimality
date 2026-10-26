# n=5 model=out iset=I1 prefix14_class=9814
cmp P0, P1
cmovge S0, P0
cmovge P0, P1
cmovle S0, P1
cmp P3, P2
cmovl S2, P2
cmovle P2, P3
mov P1, S0
cmovl P3, S2
cmp P3, S0
cmovg P1, P3
cmovge P3, S0
cmp P2, P0
mov P1, P2
