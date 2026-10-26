# n=5 model=out iset=I1 prefix14_class=12691
cmp P3, P0
cmovle S1, P0
cmovg S1, P3
cmovge P3, P0
cmp P1, P2
cmovl S0, P2
cmovl P2, P1
cmovl P1, S0
mov P0, P2
cmp P3, P0
cmovg P0, P3
cmovg P3, P2
cmp S1, P1
cmovle S0, P1
