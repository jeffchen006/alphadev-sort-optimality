# n=3 R=8 iset=I1 model=memplus source=upper:mcmc variant=AlphaDev-memory-model+memory-operands (P=memory cells; cmp/cmov may READ memory; x86-legal) L=15 (AlphaDev counting)
mov S2, P1
cmp P2, S2
mov S1, P2
cmovg S2, S1
cmovge S1, P1
cmp P0, S2
cmovge S4, P0
cmovl S4, S2
cmovl S2, P0
mov P2, S4
cmp P0, S1
cmovl S2, S1
cmovl S1, P0
mov P0, S1
mov P1, S2
