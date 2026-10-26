# n=5 model=out iset=I1 prefix14_class=9500
cmp P0, P1
cmovle S2, P1
cmovg S2, P0
cmovge P0, P1
mov S1, P2
mov S0, P0
cmp P3, P2
cmovge P2, P3
cmovg P3, S1
cmp P3, S0
cmovge P0, P3
cmovl S0, P3
cmp P2, S2
cmovle P1, S2
