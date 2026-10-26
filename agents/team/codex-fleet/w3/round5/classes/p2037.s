# n=5 model=out iset=I1 prefix14_class=2037
mov S2, P3
cmp P2, P1
cmovl S0, P1
cmovge S0, P2
cmovge P2, P1
cmp P0, P3
cmovle S2, P0
cmovg P3, P0
cmp P3, S0
cmovle P0, S0
cmovl S0, P3
mov P1, S2
cmovle P3, P0
cmp P2, P1
