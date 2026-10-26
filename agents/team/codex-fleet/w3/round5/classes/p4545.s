# n=5 model=out iset=I1 prefix14_class=4545
cmp P0, P3
mov S2, P1
cmovg S0, P0
cmovle S0, P3
cmovl P3, P0
cmp S2, P2
cmovg S2, P2
cmovle P1, P2
cmp S0, P1
cmovge P2, S0
cmovg S0, P1
cmovge P1, P2
cmp P3, S2
mov P0, S2
