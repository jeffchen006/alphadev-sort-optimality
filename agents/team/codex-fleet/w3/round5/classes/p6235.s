# n=5 model=out iset=I1 prefix14_class=6235
cmp P1, P0
cmovle S2, P1
cmovl P1, P0
cmovg S2, P0
cmp P3, P2
cmovge P0, P2
cmovge P2, P3
cmovge P3, P0
cmp P1, P2
cmovle S0, P2
cmovge S0, P1
cmovle P2, P1
mov P1, S2
cmp P3, S2
