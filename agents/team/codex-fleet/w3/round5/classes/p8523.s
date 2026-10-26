# n=5 model=out iset=I1 prefix14_class=8523
mov S0, P3
cmp P3, P2
cmovl P3, P2
cmovle P2, S0
cmp P0, P1
cmovle S2, P1
cmovge S2, P0
cmovle P1, P0
cmp P3, S2
cmovge P0, S2
cmovg S2, P3
cmovge P3, P0
cmp P1, P2
cmovge P0, P1
