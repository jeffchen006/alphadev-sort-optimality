# n=5 model=out iset=I1 prefix14_class=7180
mov S1, P3
mov S0, P0
cmp P1, S1
cmovge P3, P1
cmovg P1, S1
cmp P2, S0
cmovl S0, P2
cmovl P2, P0
cmp P1, S0
mov S2, P1
cmovg S2, S0
cmovl P1, S0
cmp P2, P3
cmovle S0, P2
