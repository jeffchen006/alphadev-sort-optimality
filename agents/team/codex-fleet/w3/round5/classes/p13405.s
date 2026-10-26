# n=5 model=out iset=I1 prefix14_class=13405
mov S2, P0
cmp P1, P2
cmovge S0, P1
cmovge P1, P2
cmovge P2, S0
cmp P3, P0
cmovg P0, P3
cmovge P3, S2
cmovl S2, P3
cmp P1, S2
cmovle S2, P1
cmovle P1, P3
cmp P2, P0
cmovle S2, P2
