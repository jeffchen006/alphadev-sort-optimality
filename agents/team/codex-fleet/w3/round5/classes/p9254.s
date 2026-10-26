# n=5 model=out iset=I1 prefix14_class=9254
mov S2, P2
cmp P3, P0
cmovg S1, P0
cmovle S1, P3
cmovle P3, P0
cmp P1, P2
cmovle S2, P1
cmovge P2, P1
cmp S2, S1
cmovle P1, S1
cmovl S1, S2
cmovle S2, P1
cmp P3, P2
cmovle S0, P3
