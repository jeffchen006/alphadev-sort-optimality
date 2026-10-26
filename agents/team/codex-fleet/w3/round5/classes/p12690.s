# n=5 model=out iset=I1 prefix14_class=12690
cmp P3, P0
cmovle S1, P0
cmovg S1, P3
cmovge P3, P0
cmp P2, P1
cmovl S0, P1
cmovl P1, P2
cmovl P2, S0
mov P0, P1
cmp P3, P0
cmovg P0, P3
cmovg P3, P1
cmp S1, P2
cmovle S2, P2
