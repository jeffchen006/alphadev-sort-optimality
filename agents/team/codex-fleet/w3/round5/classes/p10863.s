# n=5 model=out iset=I1 prefix14_class=10863
mov S0, P3
cmp P1, P0
cmovg S2, P0
cmovg P0, P1
cmovg P1, S2
mov S1, P0
cmp P2, P3
cmovge P3, P2
cmovle S0, P2
cmp P3, P0
cmovge P0, P3
cmovl S1, P3
cmp P1, S0
cmovle P3, S0
