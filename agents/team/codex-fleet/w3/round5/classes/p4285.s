# n=5 model=out iset=I1 prefix14_class=4285
cmp P2, P3
cmovg S0, P2
cmovle S0, P3
cmovg P2, P3
mov P3, P1
cmp P3, P0
cmovge P1, P0
cmovle P3, P0
cmp P2, P1
cmovl P0, P1
cmovge P0, P2
cmovle P1, P2
mov P2, S0
cmp S0, P3
