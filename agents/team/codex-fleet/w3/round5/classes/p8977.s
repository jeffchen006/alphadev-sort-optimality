# n=5 model=out iset=I1 prefix14_class=8977
mov S2, P1
cmp P3, S2
cmovge P1, P3
cmovge P3, S2
cmp P2, P0
cmovl S0, P0
cmovge S0, P2
cmovge P2, P0
cmp P1, S0
cmovle S1, S0
cmovle S0, P1
cmovle P1, S1
cmp P3, P2
cmovl S2, P3
