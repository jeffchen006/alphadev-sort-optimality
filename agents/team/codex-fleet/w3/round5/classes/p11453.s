# n=5 model=out iset=I1 prefix14_class=11453
cmp P3, P2
mov S2, P2
cmovl S2, P3
cmovle P3, P2
cmp P0, P1
mov S0, S2
cmovge P2, P1
cmovg P1, P0
cmovg P0, P2
cmp P0, S0
cmovg S2, P0
cmovle S0, P0
cmp P1, P3
cmovg P0, P3
