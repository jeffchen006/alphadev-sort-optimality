# n=5 model=out iset=I1 prefix14_class=8682
mov S2, P1
mov S0, P2
cmp P1, P3
cmovl S2, P3
cmovge P1, P3
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
mov P2, S2
cmp P0, P2
cmovg S2, P0
cmovg P0, P2
cmp P1, S0
cmovge P3, S0
