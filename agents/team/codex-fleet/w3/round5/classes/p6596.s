# n=5 model=out iset=I1 prefix14_class=6596
mov S0, P2
mov S2, P0
cmp P1, P0
cmovg P0, P1
cmovl S2, P1
cmp P2, P3
cmovle S0, P3
cmovle P3, P2
cmp P0, S0
mov S1, S0
cmovg S0, P0
cmovge P0, S1
cmp P3, S2
cmovg S1, S2
