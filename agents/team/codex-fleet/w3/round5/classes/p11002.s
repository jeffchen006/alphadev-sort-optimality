# n=5 model=out iset=I1 prefix14_class=11002
cmp P0, P3
cmovle S2, P3
cmovge S2, P0
cmovge P0, P3
cmp P2, P1
cmovl S0, P2
cmovl P2, P1
cmovl P1, S0
cmp P2, S2
mov S1, S2
cmovge S2, P2
cmovl S1, P2
cmp P0, P1
cmovle P2, P1
