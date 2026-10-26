# n=5 model=out iset=I1 prefix14_class=4960
cmp P2, P3
mov S2, P2
cmovge P2, P3
cmovle S2, P3
mov S0, P0
cmp P0, P1
cmovl P0, P1
cmovg S0, P1
cmp S0, P2
cmovle P1, S0
cmovle S0, P2
mov P3, P0
cmovl P2, P1
cmp P0, S2
