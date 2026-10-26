# n=5 model=out iset=I1 prefix14_class=11724
cmp P2, P3
mov S0, P2
cmovle S0, P3
cmovl P3, P2
mov S1, P1
cmp P1, P0
cmovg S1, P0
cmovg P0, P1
cmp P0, S0
mov S2, P0
cmovge S2, S0
cmovge S0, P0
mov S0, S2
cmp P3, S1
