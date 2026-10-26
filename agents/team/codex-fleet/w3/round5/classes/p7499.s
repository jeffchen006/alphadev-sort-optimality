# n=5 model=out iset=I1 prefix14_class=7499
cmp P2, P0
cmovg S1, P2
mov S0, P3
cmovge P2, P0
cmovg P0, S1
cmp P3, P1
cmovle S0, P1
cmovge P3, P1
cmp P2, P3
cmovl S2, P3
cmovle P3, P2
mov P3, S0
cmovge S2, P2
mov P1, S2
