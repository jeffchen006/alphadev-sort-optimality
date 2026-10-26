# n=5 model=out iset=I1 prefix14_class=1203
mov S0, P3
cmp P3, P0
cmovle P3, P0
mov S2, P2
cmovle P0, S0
cmovl S0, P3
cmp P2, P1
cmovle S2, P1
cmovge P2, P1
cmp P3, S2
cmovg P3, S2
mov S1, P3
cmovge S2, S0
mov P1, P2
