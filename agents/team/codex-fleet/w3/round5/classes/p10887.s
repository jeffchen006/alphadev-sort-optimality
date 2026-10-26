# n=5 model=out iset=I1 prefix14_class=10887
cmp P2, P1
mov S2, P1
cmovge P1, P2
cmovle S2, P2
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
mov P2, P3
cmp P2, P1
cmovle P3, P1
cmovl P1, P2
cmp S2, P0
cmovle P2, P0
