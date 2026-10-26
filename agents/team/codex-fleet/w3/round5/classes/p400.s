# n=5 model=out iset=I1 prefix14_class=400
cmp P2, P3
mov S0, P1
cmovle S2, P3
cmovg S2, P2
cmovl P3, P2
cmp S0, P0
cmovge P1, P0
cmovg P0, S0
mov P2, P1
cmp P2, P3
cmovg P1, P3
mov P1, P0
cmovl P2, P3
mov S0, P2
