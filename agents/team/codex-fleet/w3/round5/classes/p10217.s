# n=5 model=out iset=I1 prefix14_class=10217
cmp P1, P0
mov S1, P1
cmovge P1, P0
cmovl S1, P0
cmp P2, P3
cmovg S0, P3
cmovge P3, P2
cmovg P2, S0
cmp P3, S1
mov S2, P2
cmovle P0, S1
cmovle S1, P3
cmovle P3, P0
cmp S2, P1
