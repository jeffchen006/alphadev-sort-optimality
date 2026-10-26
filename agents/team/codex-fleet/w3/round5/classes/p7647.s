# n=5 model=out iset=I1 prefix14_class=7647
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
cmovge S1, P0
cmp P1, P3
mov S2, P1
cmovg S2, P3
cmovge P3, P1
cmp P2, S2
cmovle P1, P2
cmovle P2, S2
cmovl S2, P1
cmp P3, S1
mov P0, S1
