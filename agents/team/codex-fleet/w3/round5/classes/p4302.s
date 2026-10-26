# n=5 model=out iset=I1 prefix14_class=4302
cmp P0, P3
cmovg S0, P0
cmovge P0, P3
cmovle S0, P3
mov P3, P2
cmp P3, P1
cmovge P3, P1
cmovl P2, P1
mov S2, P3
cmp S2, P0
cmovle S2, P0
cmovle P0, P3
cmp P2, S0
cmovge P1, S0
