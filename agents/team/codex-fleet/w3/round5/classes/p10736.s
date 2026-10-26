# n=5 model=out iset=I1 prefix14_class=10736
mov S0, P2
cmp P3, S0
mov S1, P0
cmovge S0, P3
cmovge P3, P2
cmp P1, S1
cmovl P0, P1
cmovge S1, P1
cmp S0, S1
mov S2, S1
cmovge S2, S0
cmovg S0, S1
cmp P3, P0
cmovle S1, S0
