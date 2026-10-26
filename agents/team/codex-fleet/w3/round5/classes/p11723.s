# n=5 model=out iset=I1 prefix14_class=11723
cmp P2, P0
mov S0, P2
cmovle S0, P0
mov S1, P3
cmovl P0, P2
cmp P3, P1
cmovg S1, P1
cmovg P1, P3
cmp P1, S0
mov S2, P1
cmovge S2, S0
cmovge S0, P1
cmp P0, S1
mov S0, S2
