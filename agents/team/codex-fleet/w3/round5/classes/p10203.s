# n=5 model=out iset=I1 prefix14_class=10203
cmp P2, P3
cmovge S1, P2
mov S0, P0
cmovge P2, P3
cmovg P3, S1
cmp P1, S0
mov S1, P3
cmovl S0, P1
cmovge P0, P1
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmp P2, S0
cmovl S1, S0
