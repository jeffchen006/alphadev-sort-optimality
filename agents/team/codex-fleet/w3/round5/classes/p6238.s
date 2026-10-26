# n=5 model=out iset=I1 prefix14_class=6238
mov S2, P1
cmp S2, P0
cmovg S2, P0
cmovl P1, P0
cmp P2, P3
mov P0, P3
cmovge P3, P2
cmovge P2, P0
cmp P3, P1
cmovg S0, P3
cmovle S0, P1
cmovl P1, P3
cmp S2, P2
cmovg P3, P2
